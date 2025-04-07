#!/bin/bash

# Load modules
#module load FSL/6.0.5.1-system

fmri_nii=$1
fmri_target=`dirname $fmri_nii`

# Prepare ./bfc directory and .nii file for bias field correction
nii_name=`basename $fmri_nii .nii`
rm -r $fmri_target/bfc 2> /dev/null
mkdir $fmri_target/bfc

fslmaths $fmri_nii -Tmean $fmri_target/bfc/mean_fmri

bet2 $fmri_target/bfc/mean_fmri $fmri_target/bfc/bet_mean_fmri -f 0.3

fast -t 2 -n 3 -H 0.1 -I 4 -l 20.0 --nopve -b -B -o $fmri_target/bfc/bet_mean_fmri

fslmaths $fmri_nii -div $fmri_target/bfc/bet_mean_fmri_bias $fmri_target/bfc_$nii_name

fslchfiletype NIFTI $fmri_target/bfc_$nii_name.nii $fmri_target/bfc_$nii_name.nii.gz

