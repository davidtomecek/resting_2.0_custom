#!/bin/bash

#SBATCH --job-name=resting_pipeline_hcp
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=10gb
#SBATCH --time=24:00:00
#SBATCH --output=copy_data_wh_%j.log

target="/hydra/hydra_io/vypocty/tomecek/hcp/data_target"
export="/hydra/hydra_io/vypocty/tomecek/hcp/data_export"
scripts="/hydra/hydra_io/vypocty/tomecek/scripts"
dependencies="/hydra/hydra_io/vypocty/tomecek/scripts/resting_2.0_custom/dep"

sub_id=$1

# Create symlinks to HCP-original
sub_export="${export}/${sub_id}"
export_subdir="${sub_export}/unprocessed/3T"

# Prepare subject's target folder
sub_target="${target}/${sub_id}"
target_subdir="${sub_target}/preprocessed/3T"
mkdir -vp $target_subdir

# Project code
proj="HCP"

# TR
fmri_tr=0.72

# Locate the exported fmri nifti and create symlinks
fmri_export=`ls -1d ${export_subdir}/rfMRI_REST1`
fmri_sess=`basename $fmri_export`
fmri_export_nii=`ls ${fmri_export}/*3T_rfMRI_REST1_SIDcor.nii.gz`

fmri_target=${target_subdir}/${fmri_sess}
mkdir -vp $fmri_target
ln -s $fmri_export_nii $fmri_target
fmri_nii=`ls ${fmri_target}/*3T_rfMRI_REST1_SIDcor.nii.gz`

# Locate the exported t1 nifti and create symlinks
t1_export=`ls -1d ${export_subdir}/T1w_MPR1`
t1_sess=`basename $t1_export`
t1_export_nii=`ls ${t1_export}/*3T_T1w*nii.gz`

t1_target=${target_subdir}/${t1_sess}
mkdir -vp $t1_target
ln -s $t1_export_nii $t1_target
t1_nii=`ls ${t1_target}/*3T_T1w*nii.gz`

# Bias field correction
echo "*** Performing bias field correction ***"
fmri_sess_name=`basename $fmri_nii .nii.gz`
$scripts/resting_2.0_custom/preprocessing/bias_field_correction.sh $fmri_nii
fmri_nii=${fmri_target}/bfc_${fmri_sess_name}.nii
bfc=1

echo "fmri_target: $fmri_target"
echo "fmri_sess: $fmri_sess"
echo "fmri_nii: $fmri_nii"
echo "t1_target: $t1_target"
echo "t1_sess: $t1_sess"
echo "t1_nii: $t1_nii"

# Create sub target
mkdir -v --parents ${sub_target}/results/

# Write JSON with variables
cat <<EOF > ${sub_target}/results/resting_pipeline_params.json
{
	"export": "$export",
	"target": "$target",
	"scripts": "$scripts",
	"dependencies": "$dependencies",
	"proj": "$proj",
	"t1_export": "$t1_export",
	"t1_target": "$t1_target",	
	"t1_sess": "$t1_sess",
	"t1_nii": "$t1_nii",
	"fmri_export": "$fmri_export",
	"fmri_target": "$fmri_target",
	"fmri_sess": "$fmri_sess",
	"fmri_nii": "$fmri_nii",
	"fmri_tr": "$fmri_tr",
	"bfc": "$bfc",
	"sub_target": "$sub_target",	
	"sub_id": "$sub_id"
}
EOF

params_file=${sub_target}/results/resting_pipeline_params.json

# Run 'resting_pipeline'
echo "Running the 'resting_pipeline'"
$scripts/resting_2.0_custom/preprocessing/start_preprocessing_resting_umbriel.sh $params_file # > >(tee ${sub_target}/stdout.log) 2> >(tee ${sub_target}/stderr.log >&2)

# Run 'fc pipeline'
$scripts/resting_2.0_custom/fc/start_connectivity_resting_hcp.sh $params_file

# Final cleanup
echo "*** Final cleanup ***"
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
