%-------------------------------------------------------------------------%
% Copyright (c) 2020 Modenese L.                                          %
%                                                                         %
% Licensed under the Apache License, Version 2.0 (the "License");         %
% you may not use this file except in compliance with the License.        %
% You may obtain a copy of the License at                                 %
% http://www.apache.org/licenses/LICENSE-2.0.                             %
%                                                                         %
% Unless required by applicable law or agreed to in writing, software     %
% distributed under the License is distributed on an "AS IS" BASIS,       %
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or         %
% implied. See the License for the specific language governing            %
% permissions and limitations under the License.                          %
%                                                                         %
%    Author:   Luca Modenese,  2020                                       %
%    email:    l.modenese@imperial.ac.uk                                  %
% ----------------------------------------------------------------------- %
% This example demonstrates how to setup a simple STAPLE workflow to 
% automatically create models of the ankle joint from the JIA-MRI-ANKLE
% dataset included in the bone_datasets folder.
% ----------------------------------------------------------------------- %
clear; clc; close all
addpath(genpath('STAPLE'));

%----------%
% SETTINGS %
%----------%
% set output folder
output_models_folder = 'opensim_models';

% folder where the various datasets (and their geometries) are located.
datasets_folder = 'bone_datasets';

% dataset(s) that you would like to process specified as cell array. 
dataset = 'JIA_ANKLE_MRI';

% format of visualization geometry (obj preferred - smaller files)
vis_geom_format = 'obj';

% choose the definition of the joint coordinate systems (see documentation)
joint_defs = 'auto2020';

% body sides
sides = {'r', 'l'};
%--------------------------------------

% create model folder if required
if ~isfolder(output_models_folder); mkdir(output_models_folder); end

% setup for batch processing
for n_side = 1:2
    
    % current side
    [sign_side, cur_side] = bodySide2Sign(sides{n_side});
    
    % model name
    cur_model_name = ['example_', joint_defs,'_ankle_', upper(cur_side)];
    
    % set output model name
    output_model_file_name = [cur_model_name,'.osim'];
    
    % log printout
    log_file = fullfile(output_models_folder, [cur_model_name, '.log']);
    logConsolePrintout('on', log_file);
        
    % cell array with the name of the bone geometries to process
    bones_list = {['tibia_', cur_side], ['talus_', cur_side],['calcn_', cur_side]};
    
    % tibia and knee names including side
    tibia_name = bones_list{1};
    knee_name  = ['knee_', cur_side];
    
    % opensim model name
    model_name = [dataset,'_', upper(cur_side), '_auto'];
    
    % folder including the bone geometries in MATLAB format (triangulations)
    tri_folder = fullfile(datasets_folder, dataset,'tri');
    
    % create TriGeomSet structure for the specified geometries
    geom_set = createTriGeomSet(bones_list, tri_folder);
    
    % create bone geometry folder for visualization
    geometry_folder_name = [cur_model_name, '_Geometry'];
    geometry_folder_path = fullfile(output_models_folder, geometry_folder_name);
    writeModelGeometriesFolder(geom_set, geometry_folder_path, vis_geom_format);
    
    % initialize OpenSim model
    osimModel = initializeOpenSimModel(model_name);
    
    % create bodies
    osimModel = addBodiesFromTriGeomBoneSet(osimModel, geom_set, geometry_folder_name, vis_geom_format);
    
    % process bone geometries (compute joint parameters and identify markers)
    [JCS, BL, CS] = processTriGeomBoneSet(geom_set);
    
    %-----------------------------------
    % SPECIAL SECTION FOR PARTIAL MODELS
    %-----------------------------------
    % Using Kai2014 on the proximal tibia identifies the largest section
    % (near the ankle joint). Importantly, the reference system is aligned
    % with the principal components of the geometry, so roughly with the
    % section of the tibial shaft available. Being the largest section of
    % tibia distal, the Y axis points downwards, and needs to be inverted.
    % You can read the description of Kai_tibia algorithm in:
    % Kai, Shin, et al. Journal of biomechanics 47.5 (2014): 1229-1233.
    % https://doi.org/10.1016/j.jbiomech.2013.12.013
    JCS.(tibia_name).(knee_name).V(:,2) = -JCS.(tibia_name).(knee_name).V(:,2);
    % Z axis is ok, (detects fibula and corrected forbody  side internally)
    % X axis follows as cross-product.
    JCS.(tibia_name).(knee_name).V(:,1) = normalizeV(cross(...
                                        JCS.(tibia_name).(knee_name).V(:,2),...
                                        JCS.(tibia_name).(knee_name).V(:,3)));
    % creating an ad hoc body and joint for connecting with ground
    JCS.proxbody.free_to_ground.child = tibia_name;
    % bone geometries are in mm, but model parameters will be in m
    JCS.proxbody.free_to_ground.child_location = CS.(tibia_name).Origin/1000;
    % using computeXYZAngleSeq to transform the rotation matrix in OpenSim
    % joint orientation.
    JCS.proxbody.free_to_ground.child_orientation = computeXYZAngleSeq(...
                                        JCS.(tibia_name).(knee_name).V);
    %----------------------------------------------------------------------
    
    % create joints
    createLowerLimbJoints(osimModel, JCS, joint_defs);
    
    %----------------------------------
    % SPECIAL PART FOR PARTIAL MODELS
    %----------------------------------
    % remove markers found by Kai2014 at the tibia, as they will be
    % incorrect.
    BL = rmfield(BL, tibia_name);
    % add markers to the bones.
    %---------
    % WARNING
    %---------
    % Please note that due to the scan position of the foot, the
    % landmarking in this example is below standard quality.
    % The markers are added nevertheless to demonstrate the procedure.
    addBoneLandmarksAsMarkers(osimModel, BL);
    %-----------------------------------

    % finalize connections
    osimModel.finalizeConnections();
    
    % print OpenSim model
    osimModel.print(fullfile(output_models_folder, output_model_file_name));
    
    % inform the user about time employed to create the model
    disp('-------------------------')
    disp(['Model generated in ', sprintf('%.1f', toc), ' s']);
    disp(['Saved as ', fullfile(output_models_folder, output_model_file_name),'.']);
    disp(['Model geometries saved in folder: ', geometry_folder_path,'.'])
    disp('-------------------------')
    logConsolePrintout('off')
end

% remove paths
rmpath(genpath('msk-STAPLE/STAPLE'));