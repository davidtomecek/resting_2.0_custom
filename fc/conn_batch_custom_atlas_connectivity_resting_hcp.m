function conn_batch_custom_atlas_connectivity_resting_hcp(params_file)
%% CONN batch connecivity script

% Load parameters
params = jsondecode(fileread(params_file));

curr_time = datestr(now,'yyyymmdd_HHMMSS');
curr_date = datestr(now,'yyyymmdd');

% Results directory
res_dir = fullfile(params.sub_target,'results','conn_resting'); % results directory
mkdir(res_dir)

% Load data
functional_file = cellstr(params.fmri_smooth_nii);
structural_file = cellstr(params.t1_wc0_nii);
gm = cellstr(params.t1_wc1_nii);
wm = cellstr(params.t1_wc2_nii);
csf = cellstr(params.t1_wc3_nii);
realignment = fullfile(params.realignment);
scrubbing = fullfile(params.scrubbing);
%fmri_json = jsondecode(fileread(params.fmri_json));

% Create conn batch file
mat_file = ['conn_batch_',curr_time,'.mat'];
batch.filename = fullfile(res_dir,mat_file);
params.batch_file_fc_strin = batch.filename;

% Analysis name based on the selected denoising strategy
analysis_name = 'stringent';

%% SETUP
batch.Setup.isnew = 1;
batch.Setup.nsubjects = 1;
batch.Setup.RT = str2double(params.fmri_tr);

batch.Setup.functionals{1}{1} = functional_file;
batch.Setup.structurals = {structural_file};

% Specify masks
batch.Setup.masks.Grey.files = gm;
batch.Setup.masks.White.files = wm;
batch.Setup.masks.White.dimensions = 5;
batch.Setup.masks.CSF.files = csf;
batch.Setup.masks.CSF.dimensions = 5;

% ROIs
batch.Setup.rois.files{1} = fullfile(params.dependencies,'rois','AAL116.nii'); % AAL116 atlas
% batch.Setup.rois.files{2} = fullfile(params.dependencies,'rois','aDMN.nii'); % aDMN, admn_cmn5
% batch.Setup.rois.files{3} = fullfile(params.dependencies,'rois','pDMN.nii'); % pDMN, pdmn_cmn5
% batch.Setup.rois.files{4} = fullfile(params.dependencies,'rois','CEN.nii'); % CEN, cen_cmn5
% batch.Setup.rois.files{5} = fullfile(params.dependencies,'rois','DMN.nii'); % DMN (Gordon) bin_dmn_gordon
% batch.Setup.rois.files{6} = fullfile(params.dependencies,'rois','DAN.nii'); % DAN (Gordon) bin_dan_gordon

batch.Setup.rois.dimensions{1} = 1;
% batch.Setup.rois.dimensions{2} = 5;
% batch.Setup.rois.dimensions{3} = 5;
% batch.Setup.rois.dimensions{4} = 5;
% batch.Setup.rois.dimensions{5} = 5;
% batch.Setup.rois.dimensions{6} = 5;

% Specify analyses and output files
batch.Setup.analyses = 1;

% First-level covariates
batch.Setup.covariates.names = {'realignment','scrubbing'};
batch.Setup.covariates.files{1} = realignment;
batch.Setup.covariates.files{2} = scrubbing;

batch.Setup.done = 1;
batch.Setup.overwrite = 'Yes';

% Filtering
batch.Denoising.done = 1;
% batch.Denoising.filter = [0.008 0.09];
% batch.Denoising.confounds.names = {'White','CSF','realignment','scrubbing','Effect of rest'};
% batch.Denoising.confounds.dimensions = {5,5,6};
% batch.Denoising.confounds.deriv = {0,0,1};
% batch.Denoising.detrending = 1;
batch.Denoising.overwrite = 'Yes';

% Analysis
batch.Analysis.name = analysis_name;
batch.Analysis.done = 1;
batch.Analysis.overwrite = 'Yes';

% RUN analyses
conn_batch(batch)

% Extract AAL FC matrix and corresponding time series
extract_aal_fc_ts(params_file,batch.filename,analysis_name)

% % Extract FNC indices and corresponding time series
% extract_indices_fnc_ts(params_file,batch.filename,analysis_name)
