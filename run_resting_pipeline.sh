#!/bin/bash

export="/hydra/hydra_io/vypocty/kolenic/ISBD/ISBDpilot/N44_raw_data"
target="/hydra/hydra_io/vypocty/tomecek/isbd/data"
scripts="/hydra/hydra_io/vypocty/tomecek/scripts/resting_2.0_custom"
dependencies="/hydra/hydra_io/vypocty/tomecek/predict/scripts/dep"

# Project code
proj="ISBD"

# Locate sub export
#sub_export=`ls -1d $export/${proj}*/`
subs="/hydra/hydra_io/vypocty/tomecek/isbd/data/subs_id_20250311_1700.txt"

for sub in `cat $subs`
do
	
	sub_export=$export/$sub

	# Create sub target
	sub_id=`basename $sub_export`
	sub_target=$target/$sub_id
	mkdir -v --parents $sub_target
	
	# Locate t1 export
	#t1_name=`cat $scripts/def/series.csv | awk -F "," '{print $3}' | awk NR==1`
	t1_name="t1_sag_mpr_3D_CONNECTOM"
	t1_export=`ls -1d $sub_export/*${t1_name}`

	# Locate fmri export
	#fmri_name=`cat $scripts/def/series.csv | awk -F "," '{print $3}' | awk NR==2`
	fmri_name="fmri_resting_MB4_tr1000ms_i400_v01"
	fmri_export=`ls -1d $sub_export/*${fmri_name}`
	
	# Create t1 target
	t1_sess=`basename $t1_export`
	t1_target=$sub_target/${t1_sess}
	mkdir -v --parents $t1_target

	# Create fmri target
	fmri_sess=`basename $fmri_export`
	fmri_target=$sub_target/${fmri_sess}
	mkdir -v --parents $fmri_target

	# Create sub target
	mkdir -v --parents $sub_target/results/

	# Write JSON with variables
	echo '{
	  "export": "'"$export"'",
	  "target": "'"$target"'",
	  "scripts": "'"$scripts"'",
	  "dependencies": "'"$dependencies"'",
	  "proj": "'"$proj"'",
	  "t1_export": "'"$t1_export"'",
	  "t1_target": "'"$t1_target"'",
	  "t1_sess": "'"$t1_sess"'",
	  "fmri_export": "'"$fmri_export"'",
	  "fmri_target": "'"$fmri_target"'",
	  "fmri_sess": "'"$fmri_sess"'",
	  "sub_target": "'"$sub_target"'",
	  "sub_id": "'"$sub_id"'"
	}' > "$sub_target/results/resting_pipeline_params.json"

	json_file=$sub_target/results/resting_pipeline_params.json

	# Run 'resting_pipeline'
	sbatch $scripts/resting_pipeline.sh $json_file > >(tee ${sub_target}/stdout.log) 2> >(tee ${sub_target}/stderr.log >&2)

done
