#!/bin/bash

# Load modules
module load MRIcron/1.0.20190902

sess_name=$1
export=$2
target=$3

# Prepare target directories
mkdir -v --parents $target

# Run dcm2niix
dcm2niix -z n -f $sess_name -w 1 -o $target $export


