#!/usr/bin/env bash

# Script to process unzipped files and build parquet files

function _setup() {
	# Get local path
	localpath=$(pwd)
	# Set raw path
	export rawpath="$localpath/raw"
	export brickpath="$localpath/brick"
}

function filelist() {
	_setup;
	export IN=$(basename ${rawpath}) OUT=$(basename ${brickpath});
	find $IN -name '*.csv' \
		| perl -pe '
			s|^\Q$ENV{IN}\E|$ENV{OUT}|;
			s|\.csv$|.parquet|;
			$_ = sprintf("%6s- %s", " ", $_)
		' \
		| sort
}

function main() {
	_setup;

	echo "Local path: $localpath"

	echo "Raw path: $rawpath"

	# Create brick directory
	mkdir -p $brickpath
	echo "Brick path: $brickpath"

	Rscript R/process.R
}

case "${1:-main}" in
	filelist)
		filelist
		;;
	*)
		main
		;;
esac
