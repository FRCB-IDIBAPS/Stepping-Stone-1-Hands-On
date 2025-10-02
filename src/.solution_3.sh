#!/usr/bin/env bash
# ==========================================================
# Author:        Your Name
# Institution:   IDIBAPS
# Core Facility: Research Computing Platform
# Date:          2025-10
#
# Script Name:   .solution_3.sh
# Purpose:       Performs FASTQ compression, file transfer
#                and file integrity check afterwards with echoing steps
#
# Usage:         sh .solution_3.sh
#
# Dependencies:
#   - bash (>=4.0)
#   - coreutils (ls, cp, mv, rm, cat, head, tail)
#   - gzip / gunzip
#   - md5sum
# ==========================================================


# ==========================================================
#               STEP 0: Navigate to starting directory
# ==========================================================
echo "👉 STEP 0: Navigating to the main workshop directory..."
sleep 2
PATH_to_stepping_stone_hands_on= #[INSERT-ABSOLUTE-PATH-TO-STEPPING-STONE-HANDS-ON]
if [ -z "$PATH_to_stepping_stone_hands_on" ]; then
  echo "❌ Error: PATH_to_stepping_stone_hands_on is not set!"
  exit 1
fi

cd "$PATH_to_stepping_stone_hands_on"


# ==========================================================
#               STEP 1: Compress FASTQ file/s
# ==========================================================
echo "👉 STEP 1: Compressing FASTQ files in 'raw/'..."
sleep 2
PATH_to_raw_fastq_files=raw
cd $PATH_to_raw_fastq_files

echo "🔧 Compressing files with maximum compression (-9)..."
gzip -k9 *.fastq
sleep 2


# ==========================================================
#               STEP 2: Hash FASTQ (.gz) file/s
# ==========================================================
echo "👉 STEP 2: Generating MD5 checksums..."
sleep 2
md5_checksum_file=checksum.md5
md5sum *.gz > $md5_checksum_file
echo "✅ Checksums stored in $md5_checksum_file"
sleep 2


# ==========================================================
#               STEP 3: Transfer FASTQ file/s
# ==========================================================
echo "👉 STEP 3: Copying compressed FASTQ files to 'compressed/'..."
sleep 2
PATH_to_compressed_fastq_files=compressed
cd $PATH_to_stepping_stone_hands_on

mkdir -p $PATH_to_compressed_fastq_files
cp $PATH_to_raw_fastq_files/*.gz $PATH_to_compressed_fastq_files
echo "✅ Files copied to $PATH_to_compressed_fastq_files/"
sleep 2


# ==========================================================
#               STEP 4: Check MD5 integrity
# ==========================================================
echo "👉 STEP 4: Verifying file integrity with MD5..."
sleep 2
cd $PATH_to_compressed_fastq_files
md5sum -c ../$PATH_to_raw_fastq_files/$md5_checksum_file
echo "✅ Integrity check complete."
