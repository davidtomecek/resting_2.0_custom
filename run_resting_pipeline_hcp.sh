#!/bin/bash

scripts="/hydra/hydra_io/vypocty/tomecek/scripts"

target="/hydra/hydra_io/vypocty/tomecek/hcp/data_target"
#sub_list=`cat /store/projects/HCP-original/subs_id_20240827.txt | head -1`
sub=$1

$scripts/resting_2.0_custom/resting_pipeline_hcp.sh $sub 2>&1 | tee -a $target/${sub}_log.out
