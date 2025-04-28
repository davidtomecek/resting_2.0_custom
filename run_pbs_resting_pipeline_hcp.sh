#!/bin/bash

scripts="/store/projects/HCP-preprocessed-resting-symmetry/scripts"
target="/store/projects/HCP-preprocessed-resting-symmetry/test_data"

#sub_list=`cat /store/projects/HCP-original/subs_id_20240827.txt | head -1`
sub=$1

$scripts/resting_2.0_custom/pbs_resting_pipeline_hcp.sh $sub 2>&1 $target/${sub}_log.out
