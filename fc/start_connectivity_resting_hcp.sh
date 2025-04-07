#!/bin/bash

# Load modules
#module load MATLAB/2021a

# Input data
params_file=$1
params=$(cat $params_file)

scripts=$(echo $params | jq -r '.scripts')

# Default CONN pipeline
echo "Running the default 'stringent' denoising pipeline"
/usr/local/MATLAB/R2024b/bin/matlab -nodisplay -nosplash -nodesktop -r "addpath(genpath('$scripts')); conn_batch_custom_atlas_connectivity_resting_hcp('$params_file'); exit"

