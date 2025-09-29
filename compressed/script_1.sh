#!/usr/bin/env bash

# Define directories
DATA_DIR="data"
DEST_DIR="scripts/input_data"
CHECKSUM_FILE="checksums.md5"

# compress the files in data/
gzip "$DATA_DIR"/*.fastq

# Generate checksums and copy files
cd "$DATA_DIR"
md5sum *.fastq.gz > "$CHECKSUM_FILE"

# copy to destination folder
cd .. # going one level up to root
mkdir -p "$DEST_DIR"
cp "$DATA_DIR"/*.fastq.gz "$DEST_DIR"

# Verify checksums in the destination folder
cd "$DEST_DIR"
md5sum -c "../../$DATA_DIR/$CHECKSUM_FILE"
