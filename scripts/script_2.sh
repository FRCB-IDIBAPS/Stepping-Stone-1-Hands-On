#!/usr/bin/env bash

# Define directories
DATA_DIR="data"
DEST_DIR="scripts/input_data"
CHECKSUM_FILE="checksums.md5"

# compress the files in data/
for f in "$DATA_DIR"/*.fastq; do
    gzip "$f"
done

# Generate checksums and copy files
cd "$DATA_DIR"
for f in *.fastq.gz; do
    md5sum "$f" >> "$CHECKSUM_FILE"
done

# copy to destination folder
cd .. # going one level up to root
mkdir -p "$DEST_DIR"
for f in "$DATA_DIR"/*.fastq.gz; do
    cp "$f" "$DEST_DIR"
done

# Verify checksums in the destination folder
cd "$DEST_DIR"
md5sum -c "../../$DATA_DIR/$CHECKSUM_FILE"
