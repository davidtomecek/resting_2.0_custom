function extract_indices_fnc_ts(params_file,conn_batch_file_fc,analysis_name)
%% Extract FNC indices and corresponding time series

% Load parameters
params = jsondecode(fileread(params_file));

% FNC indices
fprintf('%s\n',['Extracting FNC matrix for sub: ',params.sub_target])

indices_roi_names = fullfile(params.dependencies,'rois','rois.txt');

fnc_indices = extract_fc(conn_batch_file_fc,analysis_name,indices_roi_names);

fnc_indices.Properties.RowNames = fnc_indices.Properties.VariableNames;

fnc_indices = [fnc_indices.aDMN_Dim1('CEN_Dim1'),...
    fnc_indices.pDMN_Dim1('CEN_Dim1'),...
    fnc_indices.DMN_Dim1('DAN_Dim1')];

fnc_indices = array2table(fnc_indices,...
    'VariableNames',{'aDMN_CEN','pDMN_CEN','DMN_DAN'});
write_table(params_file,analysis_name,indices_roi_names,'fnc',fnc_indices)

fprintf('%s\n',['Extraction of FNC matrix finished for sub: ',params.sub_target])

% Time series
fprintf('%s\n',['Extracting brain networks'' time series for sub: ',params.sub_target])

ts_net = extract_ts(conn_batch_file_fc,indices_roi_names);
write_table(params_file,analysis_name,indices_roi_names,'ts',ts_net)

fprintf('%s\n',['Extraction of brain networks'' times series finished for sub: ',params.sub_target])