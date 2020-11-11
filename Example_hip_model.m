%-------------------------------------------------------------------------%
% Copyright (c) 2020 Modenese L.                                          %
%                                                                         %
%    Author:   Luca Modenese                                              %
%    email:    l.modenese@imperial.ac.uk                                  %
% ----------------------------------------------------------------------- %
% This example demonstrates how to setup a simple STAPLE workflow to 
% automatically create a model of the hip joint from the LHDL-CT dataset 
% included in the test_geometry folder.
% ----------------------------------------------------------------------- %
clear; clc; close all
addpath(genpath('STAPLE'));

%----------%
% SETTINGS %
%----------%
% set output folder
output_models_folder = 'Opensim_models';

% set output model name
output_model_file_name = 'example_hip_joint.osim';

% folder where the various datasets (and their geometries) are located.
datasets_folder = 'bone_datasets';

% dataset(s) that you would like to process specified as cell array. 
% If you add multiple datasets they will be batched processed but you will
% have to adapt the folder and file namings below.
dataset_set = {'LHDL_CT'};

% cell array with the name of the bone geometries to process.
bones_list = {'pelvis_no_sacrum','femur_r'};

% format of visualization geometry (obj preferred - smaller files)
vis_geom_format = 'obj'; % options: 'stl'/'obj'

% choose the definition of the joint coordinate systems (see
% documentation). For hip joint creation this option has no effect.
workflow = 'auto';
%--------------------------------------

% create model folder if required
if ~isfolder(output_models_folder); mkdir(output_models_folder); end

% setup for batch processing
for n_d = 1:numel(dataset_set)
    
    % dataset id used to name OpenSim model and setup folders
    cur_dataset = dataset_set{n_d};
    
    % model name
    model_name = [dataset_set{n_d},'_auto'];
    
    % folder including the bone geometries in MATLAB format ('tri'/'stl')
    tri_folder = fullfile(datasets_folder, cur_dataset, 'tri');
    
    % create TriGeomSet structure for the specified geometries
    geom_set = createTriGeomSet(bones_list, tri_folder);
    
    % create bone geometry folder for visualization
    geometry_folder_name = 'example_hip_joint_Geometry';
    geometry_folder_path = fullfile(output_models_folder,geometry_folder_name);
    writeModelGeometriesFolder(geom_set, geometry_folder_path, vis_geom_format);
    
    % initialize OpenSim model
    osimModel = initializeOpenSimModel(model_name);
    
    % create bodies
    osimModel = addBodiesFromTriGeomBoneSet(osimModel, geom_set, geometry_folder_name, vis_geom_format);
    
    % process bone geometries (compute joint parameters and identify markers)
    [JCS, BL, CS] = processTriGeomBoneSet(geom_set);

    % create joints
    createLowerLimbJoints(osimModel, JCS, workflow);
    
    % add markers to the bones
    addBoneLandmarksAsMarkers(osimModel, BL);
    
    % finalize connections
    osimModel.finalizeConnections();
    
    % print OpenSim model
    osimModel.print(fullfile(output_models_folder, output_model_file_name));
    
    % inform the user about time employed to create the model
    disp('-------------------------')
    disp(['Model generated in ', num2str(toc)]);
    disp(['Model file save as: ', fullfile(output_models_folder, output_model_file_name),'.']);
    disp(['Model geometries saved in folder: ', geometry_folder_path,'.'])
    disp('-------------------------')
end

% remove paths
rmpath(genpath('msk-STAPLE/STAPLE'));