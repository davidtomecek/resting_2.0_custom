function [fc] = extract_fc(conn_batch_file_fc,analysis_name,roi_names)
%% Extract FC matrix

% % Load parameters
% params = jsondecode(fileread(params_file));

% Import CONN project .mat file
conn_file = load(conn_batch_file_fc);

conn_analyses = {conn_file.CONN_x.Analyses.name};

analysis_ind = find(contains(conn_analyses,analysis_name));

% Load CONN results
conn_results = load(fullfile(conn_file.CONN_x.folders.firstlevel,...
    conn_file.CONN_x.Analyses(analysis_ind).name,'resultsROI_Condition001.mat'));

names = readcell(roi_names,'Delimiter','');
roi_find = contains(conn_results.names,names);
names_found = conn_results.names(roi_find);

% Functional connectivity matrix
fc_Z = conn_results.Z(roi_find,roi_find);
fc_R = tanh(fc_Z); % Convert Fisher's z to Pearson's r

fc = array2table(fc_R,'VariableNames',names_found);

