clear;clc;
addpath(genpath('transform'));
addpath(genpath('scancontext'));
addpath(genpath('reader'));
addpath(genpath('misc'));
addpath(genpath('batch_processor'));
%% init_parm
dataset_name='Oxford';
sequence_id = '2019-01-11-13-24-51-radar-oxford-10k';
method= 'pc';
resolution=[20,60];
num_candidates = 1; 
max_range=80;
%% get des and gtposes
info = SingleTestInfo(dataset_name,sequence_id,method,resolution, max_range, num_candidates);
[data_scancontexts, data_ringkeys, data_poses]=loadData_Aug(info, 1);
%% visualize GT path
figure(1);
plot(data_poses(:,1),data_poses(:,2),'-r','LineWidth', 3);
grid on;  hold on;

%% main - global recognizer
revisit_criteria = 5; % in meter (recommend test for 5, 10, 20 meters)
num_node_enough_apart = 300; 
NUM_AUGS=3;

%% main 
exp_poses = [];
exp_ringkeys = [];
num_queries = length(data_poses);
result=zeros(num_queries-num_node_enough_apart,2);
is_revisit=zeros(num_queries-num_node_enough_apart,1);
for query_idx = 1:num_queries 
   
    query_rk(1,:) = data_ringkeys{1}(query_idx,:);
    query_rk(2,:)=data_ringkeys{2}(query_idx,:);
    query_rk(3,:)=data_ringkeys{3}(query_idx,:);
    
    query_pose = data_poses(query_idx,:);
    exp_poses = [exp_poses; query_pose];
    exp_ringkeys = [exp_ringkeys; query_rk];

    if( query_idx <=num_node_enough_apart )
       continue;
    end

    tree = createns(exp_ringkeys(1:end-NUM_AUGS*num_node_enough_apart, :), 'NSMethod', 'kdtree'); % Create object to use in k-nearest neighbor search

    % revisitness 
    [revisitness, loop_index] = isRevisitGlobalLoc(query_pose, exp_poses(1:end-num_node_enough_apart, :), revisit_criteria);
    is_revisit(query_idx-num_node_enough_apart,1)=revisitness;
    % find candidates  
    min_similarity=1;
   for AUG_index=1:NUM_AUGS
      candidates= knnsearch(tree, query_rk(AUG_index,:), 'K', num_candidates); 
      nearest_idx=ceil(candidates/NUM_AUGS);
      nearest_AUG=candidates-NUM_AUGS*(nearest_idx-1);
     
      candidate_img=data_scancontexts{nearest_AUG}{nearest_idx};
      query_align_keys= sc2vkey(data_scancontexts{AUG_index}{query_idx});
      candidate_align_keys= sc2vkey(candidate_img);
   
      rot= alignUsingSectorKey(query_align_keys, candidate_align_keys);
      align_candidate_img = circshift(candidate_img,rot,2);
      
      sim_dist = sc_dist(data_scancontexts{AUG_index}{query_idx}, align_candidate_img); 
      
       if (sim_dist<min_similarity)
           min_similarity=sim_dist;
           match_idx=nearest_idx;
       end
   end
    result(query_idx-num_node_enough_apart,:)=[match_idx,min_similarity];
    if(rem(query_idx,100)==0)
    disp( strcat(num2str(query_idx/num_queries * 100), ' % processed') );
    end
end
%% Entropy thresholds 
min_thres=min(result(:,2))+0.01;
max_thres=max(result(:,2))+0.01;
thresholds = linspace(min_thres, max_thres,100); 
num_thresholds = length(thresholds);

% Main variables to store the result for drawing PR curve 
num_hits=zeros(1, num_thresholds);
Precisions = zeros(1, num_thresholds); 
Recalls = zeros(1, num_thresholds); 
true_positive=sum(is_revisit);
 % prcurve analysis 
for thres_idx = 1:num_thresholds
  threshold = thresholds(thres_idx);
  predict_postive=0;num_hits=0;
    for frame_idx=1:length(is_revisit)
        min_dist=result(frame_idx,2);
        matching_idx=result(frame_idx,1);
        revisit=is_revisit(frame_idx,1); 
            if( min_dist <threshold)
                predict_postive=predict_postive+1;
                if(dist_btn_pose(exp_poses(frame_idx+num_node_enough_apart,:), exp_poses(matching_idx, :)) < revisit_criteria)
                    %TP
                    num_hits= num_hits + 1;
                end     
            end
    end
  
    Precisions(1, thres_idx) = num_hits/predict_postive;
    Recalls(1, thres_idx)=num_hits/true_positive;
    
end

%% save the log 
savePath = strcat("pr_result/within ", num2str(revisit_criteria), "m/");
if((~7==exist(savePath,'dir')))
    mkdir(savePath);
end
save(strcat(savePath, 'nPrecisions.mat'), 'Precisions');
save(strcat(savePath, 'nRecalls.mat'), 'Recalls');








