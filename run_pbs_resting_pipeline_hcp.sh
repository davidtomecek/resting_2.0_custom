#!/bin/bash

scripts="/store/projects/HCP-preprocessed-resting-symmetry/scripts"
target="/store/projects/HCP-preprocessed-resting-symmetry/test_data"

sub_list=`cat /store/projects/HCP-original/subs_id_20240827.txt | head -5`
#sub=$1

for sub_id in $sub_list
do
    echo $sub_id
    qsub -v sub_id=$sub_id $scripts/resting_2.0_custom/pbs_resting_pipeline_hcp.sh
done
