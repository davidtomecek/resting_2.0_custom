function extract_craddock200_fc_ts(params_file,conn_batch_file_fc,analysis_name)
%% Extract AAL FC matrix and corresponding time series

% Load parameters
params = jsondecode(fileread(params_file));

% Craddock200 FC matrix
fprintf('%s\n',['Extracting Craddock200 FC matrix for sub: ',params.sub_target])

cra_roi_names = fullfile(params.dependencies,'rois','craddock200_91_109_91.txt');

fc_cra = extract_fc(conn_batch_file_fc,analysis_name,cra_roi_names);
write_table(params_file,analysis_name,cra_roi_names,'fc',fc_cra)

fprintf('%s\n',['Extraction of Craddock200 FC matrix finished for sub: ',params.sub_target])

% Time series
fprintf('%s\n',['Extracting Craddock200 time series for sub: ',params.sub_target])

ts_cra = extract_ts(conn_batch_file_fc,cra_roi_names);
write_table(params_file,analysis_name,cra_roi_names,'ts',ts_cra)

fprintf('%s\n',['Extraction of Craddock200 times series finished for sub: ',params.sub_target])