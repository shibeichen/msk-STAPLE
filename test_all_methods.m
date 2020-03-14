%-------------------------------------------------------------------------%
% Copyright (c) 2019 Modenese L.                                          %
%                                                                         %
%    Author:   Luca Modenese, April 2018                                  %
%    email:    l.modenese@imperial.ac.uk                                  %
% ----------------------------------------------------------------------- %
clearvars;  close all

% add useful scripts
addpath(genpath('GIBOK-toolbox'));
addpath(genpath('autoMSK_functions'));
import org.opensim.modeling.*

%--------------------------------
% SETTINGS
%--------------------------------
bone_geom_folder = 'test_geometries';
ACs_folder = './ACs';
osim_folder = '';
dataset_set = {'LHDL_CT', 'P0_MRI', 'JIA_CSm6', 'TLEM2_CT', 'TLEM2_MRI'};
body_list = {'pelvis','femur_r','tibia_r','talus_r', 'calcn_r', 'patella_r'};
triGeom_file_list = {'pelvis_no_sacrum','femur_r','tibia_r','talus_r', 'calcn_r','patella_r'};
in_mm = 1;
%--------------------------------

% adjust dimensional factors based on mm / m scales
if in_mm == 1;     dim_fact = 0.001;     bone_density = 0.000001420;%kg/mm3
else; dim_fact = 1;     bone_density = 1420;%kg/m3
end

for nd = 5%1:3
    
    % looking for triangulation folder
    dataset = dataset_set{nd};
    tri_dir    = fullfile(bone_geom_folder,dataset,'tri');
    
    for nb = 1:length(body_list)
        % update variables
        cur_body_name = body_list{nb};
        cur_geom_file = fullfile(tri_dir, triGeom_file_list{nb});
        % load mesh
        cur_geom = load_mesh(cur_geom_file);
        % create the triangulation-variable
        geom_set.(cur_body_name) = cur_geom;
    end
    
    %---- PELVIS -----
%     [PelvisRS, JCS.pelvis, PelvisBL]  = GIBOK_pelvis(geom_set.pelvis);
    
    %---- FEMUR -----
%     [FemurCS1, JCS1]  = CS_femur_Kai2014(geom_set.femur_r);
%     [FemurCS, JCS2] = GIBOK_femur(geom_set.femur_r);
%     [FemurCS2, JCS2] = GIBOK_femur(geom_set.femur_r, [], 'spheres');
%     [FemurCS3, JCS3] = GIBOK_femur(geom_set.femur_r, [], 'ellipsoids');
%     [FemurCS4, JCS4] = GIBOK_femur(geom_set.femur_r, [], 'cylinder');
    
    %---- TIBIA -----
%     [TibiaCS1, JCS5] = CS_tibia_Kai2014(geom_set.tibia_r);
%     [TibiaCS2, JCS6] = GIBOK_tibia(geom_set.tibia_r, [], 'plateau');
%     [TibiaCS3, JCS7] = GIBOK_tibia(geom_set.tibia_r, [], 'ellipse');
%     [TibiaCS4, JCS8] = GIBOK_tibia(geom_set.tibia_r, [], 'centroids');
    %---- TALUS/ANKLE -----
    [TalusCS, JCS.talus_r] = GIBOK_talus(geom_set.talus_r);
    %---- CALCANEUS/SUBTALAR -----
    JCS.calcn_r = GIBOK_calcn(geom_set.calcn_r);
    %-----------------
    clear JCS
%     close all
end

% remove paths
rmpath(genpath('GIBOK-toolbox'));
rmpath('autoMSK_functions');