#!/bin/bash

export="/hydra-db/hydra_io/export57/ae321fd8/data"
target="/hydra/hydra_io/vypocty/tomecek/predict/data_ikem"
scripts="/hydra/hydra_io/vypocty/tomecek/predict/scripts/resting_2.0"
dependencies="/hydra/hydra_io/vypocty/tomecek/predict/scripts/dep"

# Project code
proj="ESO"

# Locate sub export
sub_export=`ls -1d $export/${proj}*/`

# Create sub target
sub_id=`basename $sub_export`
sub_target=$target/$sub_id
mkdir -v --parents $sub_target
	
# Locate t1 export
t1_name=`cat $scripts/def/series_ikem.csv | awk -F "," '{print $3}' | awk NR==1`
t1_export=`ls -1d $sub_export/*${t1_name}*`

# Locate fmri export
fmri_name=`cat $scripts/def/series_ikem.csv | awk -F "," '{print $3}' | awk NR==2`
fmri_export=`ls -1d $sub_export/*${fmri_name}*`
	
# Create t1 target
t1_sess=`basename $t1_export`
t1_target=$sub_target/${t1_sess}
mkdir -v --parents $t1_target

# Create fmri target
fmri_sess=`basename $fmri_export`
fmri_target=$sub_target/${fmri_sess}
mkdir -v --parents $fmri_target

# Create sub target
mkdir -v --parents $target/results/

# Write JSON with variables
cat <<EOF > $target/results/resting_pipeline_params.json
{
	"export": "$export",
	"target": "$target",
	"scripts": "$scripts",
	"dependencies": "$dependencies",
	"proj": "$proj",
	"t1_export": "$t1_export",
	"t1_target": "$t1_target",	
	"t1_sess": "$t1_sess",
	"fmri_export": "$fmri_export",
	"fmri_target": "$fmri_target",
	"fmri_sess": "$fmri_sess",
	"sub_target": "$sub_target",	
	"sub_id": "$sub_id"
}
EOF

json_file=$target/results/resting_pipeline_params.json

# Run 'resting_pipeline'
$scripts/resting_pipeline.sh $json_file > >(tee ${target}/stdout.log) 2> >(tee ${target}/stderr.log >&2)

