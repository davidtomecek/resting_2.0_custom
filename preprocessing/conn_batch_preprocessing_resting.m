function conn_batch_preprocessing_resting(params_file)
%% CONN batch preprocessing script

% Load parameters
params = jsondecode(fileread(params_file));

curr_time = datestr(now,'yyyymmdd_HHMMSS');
curr_date = datestr(now,'yyyymmdd');

% Results directory
res_dir = fullfile(params.sub_target,'results','conn_resting'); 
mkdir(res_dir)

% Load data
structural_file = cellstr(params.t1_nii);
functional_file = cellstr(params.fmri_nii);
fmri_json = jsondecode(fileread(params.fmri_json));

% Create conn batch file
mat_file = ['conn_batch_',curr_time,'.mat'];
batch.filename = fullfile(res_dir,mat_file);
params.batch_file_prep = batch.filename;

%% SETUP
batch.Setup.isnew = 1;
batch.Setup.nsubjects = 1;
batch.Setup.RT = fmri_json.RepetitionTime;

batch.Setup.functionals{1}{1} = functional_file;
batch.Setup.structurals = {structural_file};

batch.Setup.preprocessing.steps = 'default_mni';
batch.Setup.preprocessing.sliceorder = 'BIDS';

batch.Setup.done = 1;
batch.Setup.overwrite = 'Yes';

% QA
batch.QA.foldername = params.fmri_target;
batch.QA.plots = 2;

% RUN analyses
conn_batch(batch)

% Files to keep
load(batch.filename)
% T1
t1_keep = {
    params.t1_nii
    params.t1_json
    CONN_x.Setup.structural{1}{1}{1}
    CONN_x.Setup.rois.files{1}{1}{1}{1}
    CONN_x.Setup.rois.files{1}{2}{1}{1}
    CONN_x.Setup.rois.files{1}{3}{1}{1}
    };
t1_keep = string(t1_keep);
fid_t1_keep = fopen(fullfile(params.sub_target,'t1_keep.txt'),'w');
fprintf(fid_t1_keep,'%s\n',t1_keep);

% fMRI
fmri_keep = {
    params.fmri_nii_orig
    params.fmri_nii
    params.fmri_json
    CONN_x.Setup.functional{1}{1}{1}
    CONN_x.Setup.secondarydataset(3).functionals_explicit{1}{1}{1}};
fmri_keep = string(fmri_keep);
fid_fmri_keep = fopen(fullfile(params.sub_target,'fmri_keep.txt'),'w');
fprintf(fid_fmri_keep,'%s\n',fmri_keep);

% Write json file
params.fmri_swau_nii = CONN_x.Setup.functional{1}{1}{1};
params.t1_wc0_nii = CONN_x.Setup.structural{1}{1}{1};
params.t1_wc1_nii = CONN_x.Setup.rois.files{1}{1}{1}{1};
params.t1_wc2_nii = CONN_x.Setup.rois.files{1}{2}{1}{1};
params.t1_wc3_nii = CONN_x.Setup.rois.files{1}{3}{1}{1};
params.realignment = CONN_x.Setup.l1covariates.files{1}{1}{1}{1};
params.scrubbing = CONN_x.Setup.l1covariates.files{1}{3}{1}{1};

params = jsonencode(params,PrettyPrint=true);
fid_params = fopen(params_file,'w');
fprintf(fid_params,'%s',params);
fclose(fid_params);
