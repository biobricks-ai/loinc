#!/usr/bin/env bash

# Script to unzip files

# Get local path
localpath=$(pwd)
echo "Local path: $localpath"

# Set download path
export downloadpath="$localpath/download"
echo "Download path: $downloadpath"

# Create raw path
export rawpath="$localpath/raw"
mkdir -p $rawpath
echo "Raw path: $rawpath"

unzip ${downloadpath}/Loinc.zip -d ${rawpath}/
