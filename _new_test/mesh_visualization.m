% Test visualize matlab tri meshes. 

% load STAPLE
clear; clc; close all
addpath(genpath('../STAPLE'));
addpath(genpath('../STAPLE/geometry'));

test_dir = 'E:\OneDrive - Griffith University\____Current_Project_data\_Project_2_KNEE\_Keypoint_ID\femur_geometric_test\femur\riad_masterdataset\stl';
filedir = fullfile (test_dir,'femur_r_M01.stl')
fem = load_mesh(filedir);

trimesh (fem)

% three axis of the point clouds
x = pc(:,1); y = pc(:,2); z = pc(:,3);