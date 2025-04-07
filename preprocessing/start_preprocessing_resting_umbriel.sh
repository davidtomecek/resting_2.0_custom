#!/bin/bash

# Load modules
#module load MATLAB/2021a

# Input data
params_file=$1
params=$(cat $params_file)

scripts=$(echo $params | jq -r '.scripts')
target=$(echo $params | jq -r '.target')
sub_target=$(echo $params | jq -r '.sub_target')
sub_id=$(echo $params | jq -r '.sub_id')

# Default CONN pipeline
echo "Running the default MNI pipeline"
/usr/local/MATLAB/R2024b/bin/matlab -nodisplay -nosplash -nodesktop -r "addpath(genpath('$scripts')); conn_batch_preprocessing_resting_hcp('$params_file'); exit" &

matlab_pid=$!

echo $matlab_pid

pidstat -u -r -p $matlab_pid 1 >> $target/${sub_id}_cpu_ram.log