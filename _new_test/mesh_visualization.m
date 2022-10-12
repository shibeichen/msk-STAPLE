% Test visualize matlab tri meshes. 

% load STAPLE
clear; clc; close all
addpath(genpath('../STAPLE'));
addpath(genpath('../STAPLE/geometry'));

% import from dir path
% test_dir = 'E:\OneDrive - Griffith University\____Current_Project_data\_Project_2_KNEE\_Keypoint_ID\femur_geometric_test\femur\riad_masterdataset\stl';
% filedir = fullfile (test_dir,'femur_r_M01.stl')

% import from file 
[file,path] = uigetfile('*.stl','import a stl file');
filedir = fullfile (path,file)
fem = load_mesh(filedir);

% Rotate Martina's data into conventional coordinate axis ( x - meidal
% lateral, y - anterior posterior, z superior and inferior)

% Plotting 

% pcshow 
pcshow(fem.Points)

% scatter3 
% for a point cloud p, plot in {} mm, in {} color
% scatter3(p(:,1),p(:,2),p(:,3),0.1,'r')
