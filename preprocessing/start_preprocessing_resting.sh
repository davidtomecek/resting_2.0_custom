#!/bin/bash

# Load modules
module load MATLAB/2021a

# Input data
params_file=$1
params=$(cat $params_file)

scripts=$(echo $params | jq -r '.scripts')

# Default CONN pipeline
echo "Running the default MNI pipeline"
matlab -nodisplay -nosplash -nodesktop -r "addpath(genpath('$scripts')); conn_batch_preprocessing_resting('$params_file'); exit"
