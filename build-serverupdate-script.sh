#!/usr/bin/env bash
#
# Create script that places the dcw-gmt archive on the SOEST data server
# and extracts its content and updates the geography/dcw DCW files
# P. Wessel, Nov-24-2021

# Get DCW version and directory arguments from command line
DCW_VERSION=$1
GMTSERVER_DIR=$2

# Build a dcw-update.sh script for the data server to execute
cat << EOF > /tmp/dcw-update.sh
#!/bin/bash
# Script to be placed on the data server's /tmp directory and executed
# Extracts files from tarball then replaces existing dcw-update files
# and deletes itself. Files will reside in ${GMTSERVER_DIR}
# 1. Change directory
cd ${GMTSERVER_DIR}
# 2. Download the DCW tarball
curl -OLs https://github.com/GenericMappingTools/dcw-gmt/releases/download/${DCW_VERSION}/dcw-gmt-${DCW_VERSION}.tar.gz
# 3. Extract/update files if the download succeeded
if [ -f dcw-gmt-${DCW_VERSION}.tar.gz ]; then
	tar xzf dcw-gmt-${DCW_VERSION}.tar.gz
	mv -f dcw-gmt-${DCW_VERSION}/* .
	rm -f dcw-gmt-${DCW_VERSION}.tar.gz
	rm -rf dcw-gmt-${DCW_VERSION}
fi
# Self-destruct
rm -f /tmp/dcw-update.sh
EOF
