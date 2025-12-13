#!/usr/bin/env bash

# Script to process unzipped files and build parquet files

# Get local path
localpath=$(pwd)
echo "Local path: $localpath"

# Set raw path
export rawpath="$localpath/raw"
echo "Raw path: $rawpath"

# Create brick directory
export brickpath="$localpath/brick"
mkdir -p $brickpath
echo "Brick path: $brickpath"

Rscript R/process.R
