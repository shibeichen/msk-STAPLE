% geom_analysis_femur 

% load STAPLE
clear; clc; close all
addpath(genpath('../STAPLE'));
addpath(genpath('../STAPLE/geometry'));

%--data dir--%



% Testing other dataset
dir = 'E:\OneDrive - Griffith University\____Current_Project_data\_Project_2_KNEE\_Keypoint_ID\femur_geometric_test\femur\riad_masterdataset\stl';

% dir = 'E:\OneDrive - Griffith University\____Current_Project_data\_Project_2_KNEE\_Keypoint_ID\femur_geometric_test\femur\Martina_data\stl'

% specify the bone being processed 
fem_file = fullfile(dir, 'femur_r_M01.stl');

% using file selection dialog box

% fem_file = uigetfile ('Input femur (.stl) for geometric analysis')


% test STAPLE bone 
% dir = 'E:\OneDrive - Griffith University\____Current_Project_data\_Project_2_KNEE\_Keypoint_ID\femur_geometric_test\femur\STAPLE_test_data';
% fem_file = fullfile(dir, 'femur_r.mat');


% load the tri .mat
fem_tri = load_mesh(fem_file);

% visualise 
% trimesh(fem_tri)
pcshow(fem_tri.Points)

% parameters
side = 'r'

% Run geo analysis
[CS, JCS, FemurBL] = GIBOC_femur(fem_tri,side, 'cylinder')




