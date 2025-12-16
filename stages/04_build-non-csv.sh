#!/usr/bin/env bash

# Script to copy specific files into brick

set -eu

function _setup() {
	# Get local path
	localpath=$(pwd)
	# Set raw path
	export rawpath="$localpath/raw"
	export brickpath="$localpath/brick"
}

function _files() {
      find $(basename ${rawpath})/ \
	      -type f \
	      \( \
		      -name '*.owl' \
		      -o -name '*.xml' \
		\)
}

function filelist() {
	_setup;
	export IN=$(basename ${rawpath}) OUT=$(basename ${brickpath});
	_files \
		| perl -pe '
			s|^\Q$ENV{IN}\E|$ENV{OUT}|;
			$_ = sprintf("%6s- %s", " ", $_)
		' \
		| sort
}

function main() {
	_setup;
	export IN=$(basename ${rawpath}) OUT=$(basename ${brickpath});

	echo "Local path: $localpath"

	echo "Raw path: $rawpath"

	# Create brick directory
	mkdir -p $brickpath
	echo "Brick path: $brickpath"

	_files | parallel '
		dest={= s<^\Q$ENV{IN}\E/><$ENV{OUT}/> =};
		mkdir -p "$(dirname "$dest")";
		cp -v {} "$dest"
	'
}

case "${1:-main}" in
	filelist)
		filelist
		;;
	*)
		main
		;;
esac
