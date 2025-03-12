function write_table(params_file,analysis_name,roi_names,data_type,tbl)
%% Write table

% Load parameters
params = jsondecode(fileread(params_file));

[~,roi_filename,~] = fileparts(roi_names);

if nargin == 1
    tbl_filename = [roi_filename,'_',data_type,'_resting.csv'];
else
    tbl_filename = [roi_filename,'_',data_type,'_resting_',analysis_name,'.csv'];
end

writetable(tbl,fullfile(params.sub_target,'results',tbl_filename))