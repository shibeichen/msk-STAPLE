% geom_analysis_femur 

% load STAPLE
clear; clc; close all
addpath(genpath('../STAPLE'));
addpath(genpath('../STAPLE/geometry'));

%--data dir--%

% STAPLE femur tri dir
dir_test_STAPLE_tri = 'C:\Users\87123\OneDrive - Griffith University\____Current_Project_data\_Project_2_KNEE\_Keypoint_ID\femur_geometric_test\femur\femur_tri_from_STAPLE_TLEM2_CVT';

% Testing femur tri dir
dir = 'C:\Users\87123\OneDrive - Griffith University\____Current_Project_data\_Project_2_KNEE\_Keypoint_ID\femur_geometric_test\femur\tri';


% specify the bone being processed 
fem_file = fullfile(dir_test_STAPLE_tri, 'femur_r.mat');

% fem_file = fullfile(dir, 'TD12_femur_r.mat');

% load the tri .mat
fem_tri = load_mesh(fem_file);

% visualise 
trimesh(fem_tri)

% parameters
side = 'r'

GIBOC_femur(fem_tri,side, 'cylinder')