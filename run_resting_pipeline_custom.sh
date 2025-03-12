#!/bin/bash

scripts="/hydra/hydra_io/vypocty/tomecek/predict/scripts/resting_2.0_custom"

sub_list=`cat /hydra/hydra_io/vypocty/tomecek/eso/eso190ml/data_ikem/subs_190_20250211_1547.txt`

for sub in $sub_list
do

	sbatch $scripts/resting_pipeline_custom.sh $sub

done
