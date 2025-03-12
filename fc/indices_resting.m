function indices_resting(params_file,analysis_name)
%% Extract indices

% Load parameters
params = jsondecode(fileread(params_file));

dependencies = params.dependencies;
target = params.target;
sub_target = params.sub_target;
batch_file_prep = params.batch_file_prep;

fprintf('%s\n',['Extracting indices for sub: ',sub_target])

% Import CONN project .mat file
conn_file = load(batch_file_prep);

conn_analyses = {conn_file.CONN_x.Analyses.name};

if nargin == 1
    analysis_ind = 1;
else
    analysis_ind = find(contains(conn_analyses,analysis_name));
end

% 'resting' condition
resting = load(fullfile(conn_file.CONN_x.folders.firstlevel,...
    conn_file.CONN_x.Analyses(analysis_ind).name,'resultsROI_Condition001.mat'));

% Indices
% atlas = contains(resting.names,'AAL');
ind_names = readcell(fullfile(dependencies,'rois','indices.txt'),'Delimiter','');
admn_ind = find(contains(resting.names,ind_names{1}));
pdmn_ind = find(contains(resting.names,ind_names{2}));
cen_ind = find(contains(resting.names,ind_names{3}));
dmn_ind = find(contains(resting.names,ind_names{4}));
dan_ind = find(contains(resting.names,ind_names{5}));

% Use the 1st PCA components to calculate the indices
admn_cen = resting.Z(admn_ind(1),cen_ind(1));
pdmn_cen = resting.Z(pdmn_ind(1),cen_ind(1)); 
dmn_dan = resting.Z(dmn_ind(1),dan_ind(1)); 

indices = array2table([admn_cen,pdmn_cen,dmn_dan],...
    'VariableNames',{'aDMN_CEN','pDMN_CEN','DMN_DAN'});

if nargin == 1
    indices_filename = 'indices_resting.csv';
else
    indices_filename = ['indices_resting_',analysis_name,'.csv'];
end

writetable(indices,fullfile(target,'results',indices_filename))

fprintf('%s\n',['Extraction of indices finished for sub: ',sub_target])