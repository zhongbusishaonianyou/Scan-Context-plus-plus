# Scan Context++: Structural Place Recognition Robust to Rotation and Lateral Variations in Urban Environments(TRO 2022)
- Note:this the evaluation by using pr curve for Scan context++
- paper code : https://github.com/gisbi-kim/scancontext_tro

# pr result
 - ## KITTI results (using Aug_pc)
|                                                    KITTI00   |           KITTI02                                            |               KITTI08                                        |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
|![00](https://github.com/user-attachments/assets/6bb41cae-b407-429f-b24f-810cb12a6cb4) | ![02](https://github.com/user-attachments/assets/995f397d-2913-4be9-834e-2b3f299b1a47) |![08](https://github.com/user-attachments/assets/fa5bcc7b-8172-4466-b1b3-95e0cb46d927) |

 - ## MulRan results (using Aug_pc)
|                                                                             gt_path|         pr curve                                                                                  |
| -------------------------------------------------------------------------------------------| ----------------------------------------------------------------------------------------- | 
|![4444](https://github.com/user-attachments/assets/e69efd75-d716-46ed-942b-70614ae68a9a) |![riverside02](https://github.com/user-attachments/assets/67183e80-ee62-4aba-a9ec-93056cf9ff36)|
|![qq](https://github.com/user-attachments/assets/24598c6f-9213-4671-ae34-fec2c075da8d)   | ![DCC02](https://github.com/user-attachments/assets/201f30bb-e38f-40a1-8c5d-6b670a477826)     |
- ## KITTI results (using Aug_cc)
|                                                                             KITTI 02|         riverside02                   |      DCC02                                                   |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
|![cc_02](https://github.com/user-attachments/assets/4b364baa-2b3f-4adf-8569-dd653a0e3202)|![cc_02](https://github.com/user-attachments/assets/d61d0332-0f3a-4025-9541-4f63e9c271af)|![dc11c02](https://github.com/user-attachments/assets/ee6fcbfc-77c6-47ef-ac57-aca06bee949b)|
# results analysis
SC++ solves revisits with lateral translations by creating an enhanced descriptor PC and an enhanced CC to solve inverse revisit events with smaller lateral translations.SC++ has a significant performance improvement compared to SC on the KITTI02, KITTI08, and Riverside02 sequences.However, realistic revisit events typically occur with both viewpoint rotation and lateral translation, and the augmented PC performance is limited, e.g., on sequence DCC02. Next, I will attempt to evaluate the RING++ method, which decouples lateral translation and rotation.
# cite
```
@ARTICLE{9610172,
  author={Kim, Giseop and Choi, Sunwook and Kim, Ayoung},
  journal={IEEE Transactions on Robotics}, 
  title={Scan Context++: Structural Place Recognition Robust to Rotation and Lateral Variations in Urban Environments}, 
  year={2022},
  volume={38},
  number={3},
  pages={1856-1874},
  keywords={Robot sensing systems;Laser radar;Robots;Radar;Visualization;Robustness;Encoding;Localization;place recognition;range sensors},
  doi={10.1109/TRO.2021.3116424}}
 ```
