% Test visualize matlab tri meshes. 

% load STAPLE
clear; clc; close all
addpath(genpath('../STAPLE'));
addpath(genpath('../STAPLE/geometry'));

test_dir = "C:\Users\87123\Documents\MATLAB\msk-STAPLE\bone_datasets\ICL_MRI\tri";
filedir = fullfile (test_dir,"femur_r")
fem = load_mesh(filedir);

trimesh (fem)

% three axis of the point clouds
x = pc(:,1); y = pc(:,2); z = pc(:,3);