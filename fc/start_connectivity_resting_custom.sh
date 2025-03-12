#!/bin/bash

# Load modules
module load MATLAB/2021a

# Input data
params_file=$1
params=$(cat $params_file)

scripts=$(echo $params | jq -r '.scripts')

# Default CONN pipeline
echo "Running the default 'stringent' denoising pipeline"
matlab -nodisplay -nosplash -nodesktop -r "addpath(genpath('$scripts')); conn_batch_custom_atlas_connectivity_resting('$params_file'); exit"

