function [descs_list, invkeys_list, poses] = loadData_Aug(testinfo, SKIP_FRAMES)
        
%% Newely make
    if ~ exist(testinfo.save_path_core_, 'dir')  
      
        if( strcmp(testinfo.dataset_, 'KITTI'))
          [descs_list, invkeys_list, poses] = makeAugmentedExperienceAllFramesTreeMerge(testinfo, SKIP_FRAMES);    
       else
          [descs_list, invkeys_list, poses] = makeAugmentedExperienceEquiDistTreeMerge(testinfo, SKIP_FRAMES);
       end
        % save 
        mkdir(testinfo.save_path_);

        descs_filename = fullfile(testinfo.save_path_, 'descs_list.mat');
        invkeys_filename = fullfile(testinfo.save_path_, 'invkeys_list.mat');
        poses_filename = fullfile(testinfo.save_path_, 'poses.mat');

        save(descs_filename, 'descs_list');
        save(invkeys_filename, 'invkeys_list');
        save(poses_filename, 'poses');
        
        disp('- successfully made.');

        %% Or load existing ones 
    else
        saved_time = osdir(testinfo.save_path_core_); saved_time = saved_time{1};
        descs_filename = fullfile(testinfo.save_path_core_, saved_time, 'descs_list.mat');
        invkeys_filename = fullfile(testinfo.save_path_core_, saved_time, 'invkeys_list.mat');
        poses_filename = fullfile(testinfo.save_path_core_, saved_time, 'poses.mat');

        load(descs_filename);
        load(invkeys_filename);
        load(poses_filename);

        disp('- successfully loaded.');
    end

end

