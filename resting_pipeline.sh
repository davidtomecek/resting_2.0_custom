#!/bin/bash

#SBATCH --job-name=resting_pipeline_custom
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=10gb
#SBATCH --time=03:00:00
#SBATCH --output=resting_pipeline_custom_%j.log

# Load modules
module load FSL/6.0.5.1-system
module load MATLAB/2021a

date=`date +%Y%m%d_%H%M%S`

# Input data
params_file=$1
params=$(cat $params_file)

target=$(echo "$params" | jq -r '.target')
t1_export=$(echo $params | jq -r '.t1_export')
t1_target=$(echo $params | jq -r '.t1_target')
fmri_export=$(echo $params | jq -r '.fmri_export')
fmri_target=$(echo $params | jq -r '.fmri_target')
sub_target=$(echo $params | jq -r '.sub_target')
scripts=$(echo $params | jq -r '.scripts')
dependencies=$(echo $params | jq -r '.dependencies')
sub_id=$(echo $params | jq -r '.sub_id')
t1_sess=$(echo $params | jq -r '.t1_sess')
fmri_sess=$(echo $params | jq -r '.fmri_sess')

# Convert DICOM to NIFTI
echo "*** Converting t1 DICOM images to NIFTI format ***"
t1_sess_name="t1"
$scripts/preprocessing/convert_dicom_nifti.sh $t1_sess_name $t1_export $t1_target
t1_nii=${t1_target}/${t1_sess_name}.nii
t1_json=${t1_target}/${t1_sess_name}.json

echo "*** Converting fMRI DICOM images to NIFTI format ***"
fmri_sess_name="fmri_resting"
$scripts/preprocessing/convert_dicom_nifti.sh $fmri_sess_name $fmri_export $fmri_target
fmri_nii=${fmri_target}/${fmri_sess_name}.nii
fmri_nii_orig=${fmri_target}/${fmri_sess_name}.nii
fmri_json=${fmri_target}/${fmri_sess_name}.json
bfc=0

# Head coil type
coiltype=`jq '.ReceiveCoilName' $fmri_json | tr -cd [:digit:] | xargs printf "%d\n"`

# Check if the 64-channel head coil was used - if yes, do the bias field correction
if [ $coiltype -eq 64 ] ; then

	echo "*** 64-channel head coil used - performing bias field correction ***"
	$scripts/preprocessing/bias_field_correction.sh $fmri_nii
	fmri_nii=${fmri_target}/bfc_${fmri_sess_name}.nii
	bfc=1

fi

# Run "preprocessing" pipeline
echo "*** Preprocessing in progress ***"
echo $date
echo $scripts
echo $sub_target
echo $t1_nii
echo $t1_json
echo $fmri_nii
echo $fmri_json

params=$(echo "$params" | jq --arg t1_nii "$t1_nii" --arg t1_json "$t1_json" --arg fmri_nii_orig "$fmri_nii_orig" --arg fmri_nii "$fmri_nii" --arg fmri_json "$fmri_json" --arg coiltype $coiltype --arg bfc $bfc '.t1_nii = $t1_nii | .t1_json = $t1_json | .fmri_nii_orig = $fmri_nii_orig | .fmri_nii = $fmri_nii | .fmri_json = $fmri_json | .coiltype = $coiltype | .bfc = $bfc')
echo "$params" > $params_file

$scripts/preprocessing/start_preprocessing_resting.sh $params_file
echo "*** Preprocessing finished ***"

# Run "fc" pipeline
#echo "*** Running FC pipeline ***"
#$scripts/fc/start_connectivity_resting.sh $params_file
#echo "*** FC pipeline finished ***"

# Final cleanup
#echo "*** Final cleanup ***"
#mkdir -v --parents ${target}/results/${sub_id}/${t1_sess}
#mkdir -v --parents ${target}/results/${sub_id}/${fmri_sess}

# Copy the files that will be uploaded to Hydra
#cp -v ${fmri_target}/QA_NORM_functional*jpg ${target}/results/QA_NORM_functional_resting.jpg
#cp -v ${fmri_target}/art_regression_outliers_and_movement*.mat ${target}/results/art_regression_outliers_and_movement_resting.mat
#cp -v ${fmri_target}/rp*.txt ${target}/results/rp_resting.txt

#cp -v ${fmri_target}/art_regression_outliers_and_movement*.mat ${target}/results/${sub_id}/${fmri_sess}/art_regression_outliers_and_movement_resting.mat
#cp -v ${fmri_target}/art_regression_outliers_au*.mat ${target}/results/${sub_id}/${fmri_sess}/art_regression_outliers_resting.mat
#cp -v ${fmri_target}/art_regression_timeseries*.mat ${target}/results/${sub_id}/${fmri_sess}/art_regression_timeseries_resting.mat
#cp -v ${fmri_target}/rp*.txt ${target}/results/${sub_id}/${fmri_sess}/rp_resting.txt
#cp -v $(cat ${sub_target}/fmri_keep.txt) ${target}/results/${sub_id}/${fmri_sess}
#cp -v ${params_file} ${target}/results/${sub_id}/${fmri_sess}/
#cp -v $(cat ${sub_target}/t1_keep.txt) ${target}/results/${sub_id}/${t1_sess}

#tar -zcvf ${target}/results/t1.tar.gz -C ${target}/results/ ${sub_id}/${t1_sess}
#tar -zcvf ${target}/results/fmri_resting.tar.gz -C ${target}/results/ ${sub_id}/${fmri_sess}

#rm -rv $sub_target
#rm -rv ${target}/results/conn_resting
#rm -rv ${target}/results/fmri_resting
#rm -rv ${target}/results/t1
#rm -v $params_file

#chmod 0775 ${target}
#chmod 0775 ${target}/results
#chmod 0664 ${target}/results/*

#git_last_commit=$(git -C $scripts rev-parse --verify HEAD)

#echo "Version used for the analysis - git hash:" $git_last_commit
echo "Resting 2.0 Pipeline finished $(date) following files were created and will be stored: $sub_target/results/"
echo "PIPELINE-COMPLETE"
