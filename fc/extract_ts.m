function [ts] = extract_ts(conn_batch_file_fc,roi_names)
%% Extract time series

% % Load parameters
% params = jsondecode(fileread(params_file));

% Import CONN project .mat file
conn_file = load(conn_batch_file_fc);

% Load CONN results
conn_results = load(fullfile(conn_file.CONN_x.folders.preprocessing,...
    'ROI_Subject001_Condition001.mat'));

% Find the corresponding columns and prepare their names
names = readcell(roi_names,'Delimiter','');
ts_find = contains(conn_results.names,names);

% Time series
ts = conn_results.data(ts_find);
ts = cell2mat(cellfun(@(x) x(:,1),ts,'UniformOutput',false));
ts = array2table(ts,'VariableNames',names);

