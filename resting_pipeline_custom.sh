#!/bin/bash

#SBATCH --job-name=resting_pipeline_custom
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=10gb
#SBATCH --time=01:00:00
#SBATCH --output=resting_pipeline_custom_%j.log

sub=$1

target="/hydra/hydra_io/vypocty/tomecek/eso/eso190ml/data_ikem"
ext_dir="hydra-db/hydra_io/hydra-pipelines/target/startlog*/results"
scripts="/hydra/hydra_io/vypocty/tomecek/predict/scripts/resting_2.0_custom"

sub_id=`basename $sub`
mkdir -v $target/$sub_id

tar -xvzf $sub/fmri_resting.tar.gz -C $target/$sub_id
rest_dir_ext=`ls -1d $target/$sub_id/$ext_dir/fmri_resting/*RESTING*`
rest_sess=`basename $rest_dir_ext`
mkdir -v $target/$sub_id/$rest_sess/
mv -v $rest_dir_ext/* $target/$sub_id/$rest_sess/
echo $rest_dir_ext

tar -xvzf $sub/t1.tar.gz -C $target/$sub_id
t1_dir_ext=`ls -1d $target/$sub_id/$ext_dir/t1/*t1*`
t1_sess=`basename $t1_dir_ext`
mkdir -v $target/$sub_id/$t1_sess/
mv -v $t1_dir_ext/* $target/$sub_id/$t1_sess/
echo $t1_dir_ext

rm -rv $target/$sub_id/hydra-db/

# Input data
params_file=$target/$sub_id/$rest_sess/resting_pipeline_params.json
params=$(cat $params_file)

echo $params_file

dependencies=$(echo $params | jq -r '.dependencies')
#target=$(echo $params | jq -r '.target')
#sub_id=$(echo $params | jq -r '.sub_id')
#t1_sess=$(echo $params | jq -r '.t1_sess')
#fmri_sess=$(echo $params | jq -r '.fmri_sess')
sub_target=$target/$sub_id
realignment=$target/$sub_id/$rest_sess/rp_resting.txt
scrubbing=$target/$sub_id/$rest_sess/art_regression_outliers_resting.mat
fmri_json=$target/$sub_id/$rest_sess/fmri_resting.json
fmri_swau_nii=$target/$sub_id/$rest_sess/swaufmri_resting.nii
t1_wc0_nii=$target/$sub_id/$t1_sess/wc0ct1.nii
t1_wc1_nii=$target/$sub_id/$t1_sess/wc1ct1.nii
t1_wc2_nii=$target/$sub_id/$t1_sess/wc2ct1.nii
t1_wc3_nii=$target/$sub_id/$t1_sess/wc3ct1.nii

echo $realignment

params=$(echo "$params" | jq --arg scripts "$scripts" --arg dependencies "$dependencies" --arg realignment "$realignment" --arg scrubbing "$scrubbing" --arg fmri_json "$fmri_json" --arg fmri_swau_nii "$fmri_swau_nii" --arg t1_wc0_nii $t1_wc0_nii --arg t1_wc1_nii $t1_wc1_nii --arg t1_wc2_nii $t1_wc2_nii --arg t1_wc3_nii $t1_wc3_nii --arg target $target --arg sub_target $sub_target '.scripts = $scripts | .dependencies = $dependencies | .realignment = $realignment | .scrubbing = $scrubbing | .fmri_json = $fmri_json | .fmri_swau_nii = $fmri_swau_nii | .t1_wc0_nii = $t1_wc0_nii | .t1_wc1_nii = $t1_wc1_nii | .t1_wc2_nii = $t1_wc2_nii | .t1_wc3_nii = $t1_wc3_nii | .target = $target | .sub_target = $sub_target')
echo "$params" > $params_file

# Run "fc" pipeline
echo "*** Running FC pipeline ***"
$scripts/fc/start_connectivity_resting_custom.sh $params_file
echo "*** FC pipeline finished ***"
