function extract_aal_fc_ts(params_file,conn_batch_file_fc,analysis_name)
%% Extract AAL FC matrix and corresponding time series

% Load parameters
params = jsondecode(fileread(params_file));

% AAL FC matrix
fprintf('%s\n',['Extracting AAL FC matrix for sub: ',params.sub_target])

aal_roi_names = fullfile(params.dependencies,'rois','AAL116.txt');

fc_aal = extract_fc(conn_batch_file_fc,analysis_name,aal_roi_names);
write_table(params_file,analysis_name,aal_roi_names,'fc',fc_aal)

fprintf('%s\n',['Extraction of AAL FC matrix finished for sub: ',params.sub_target])

% Time series
fprintf('%s\n',['Extracting AAL time series for sub: ',params.sub_target])

ts_aal = extract_ts(conn_batch_file_fc,aal_roi_names);
write_table(params_file,analysis_name,aal_roi_names,'ts',ts_aal)

fprintf('%s\n',['Extraction of AAL times series finished for sub: ',params.sub_target])