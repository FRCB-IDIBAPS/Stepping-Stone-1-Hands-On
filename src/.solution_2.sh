#!/usr/bin/env bash
# ==========================================================
# Author:        Your Name
# Institution:   IDIBAPS
# Core Facility: Research Computing Platform
# Date:          2025-10
#
# Script Name:   .solution_2.sh
# Purpose:       Performs FASTQ compression and file transfer using loops,
#                and file integrity check afterwards
#
# Usage:         bash .solution_2.sh
#
#
# Dependencies:
#   - bash (>=4.0)
#   - coreutils (ls, cp, mv, rm, cat, head, tail)
#   - gzip / gunzip
#   - md5sum
#
# Notes:
#   - Use provided variables with input/output files 
#     or directories
# ==========================================================
echo "-----------------------------------------------------"
echo " STEPPING-STONE: BIODATASERIES 1"
echo " Filter compression and transfer pipeline"
echo "-----------------------------------------------------"
sleep 2
echo " Initializing pipeline"


# ==========================================================
#               STEP 0: Navigate to starting directory
# ==========================================================
echo -ne " [STEP 0] Moving to workshop directory"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
PATH_to_stepping_stone_hands_on= #[INSERT-ABSOLUTE-PATH-TO-STEPPING-STONE-HANDS-ON]
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if [ -z "$PATH_to_stepping_stone_hands_on" ]; then
    echo -ne "\r\033[K [STEP 0] Moving to workshop directory                           [FAILED]\n"
    echo -ne "\r\033[K          CAUSE: Failed to define a valid workshop directory\n"
    exit 1
fi
cd "$PATH_to_stepping_stone_hands_on"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
sleep 1
echo -ne "\r\033[K [STEP 0] Moving to workshop directory                           [COMPLETED]\n"


# ==========================================================
#               STEP 1: Compress FASTQ file/s
# ==========================================================
sleep 2
echo " [STEP 1] Compressing FASTQ files from raw/ directory"
PATH_to_raw_fastq_files=raw

#   1.1: Navigate to raw/ directory
echo -ne " \t[STEP 1.1] Navigating to raw/ directory"
cd "$PATH_to_raw_fastq_files"
sleep 1
echo -ne "\r\033[K \t[STEP 1.1] Navigating to raw/ directory                  [COMPLETED]\n"

#   1.2: Compress FASTQ files (loop)
echo -ne " \t[STEP 1.2] Compressing FASTQ files"
for f in *.fastq; do
    gzip -k9 "$f"
done
sleep 1
echo -ne "\r\033[K \t[STEP 1.2] Compressing FASTQ files                       [COMPLETED]\n"


# ==========================================================
#               STEP 2: Hash FASTQ (.gz) file/s
# ==========================================================
sleep 2
echo " [STEP 2] Hashing FASTQ files"
md5_checksum_file=checksum.md5

#   2.1: Hash all compressed files and redirect to .md5
echo -ne " \t[STEP 2.1] Storing all FASTQ hash in .md5 file"
for f in *.gz; do
    md5sum "$f" >> "$md5_checksum_file"
done
sleep 1
echo -ne "\r\033[K \t[STEP 2.1] Storing all FASTQ hash in .md5 file           [COMPLETED]\n"


# ==========================================================
#               STEP 3: Transfer FASTQ file/s
# ==========================================================
sleep 2
echo " [STEP 3] Transferring FASTQ files"
PATH_to_compressed_fastq_files=compressed

#   3.1: Navigate back to workshop directory
echo -ne " \t[STEP 3.1] Navigating to workshop directory"
cd "$PATH_to_stepping_stone_hands_on"
sleep 1
echo -ne "\r\033[K \t[STEP 3.1] Navigating to workshop directory              [COMPLETED]\n"

#   3.2: Create compressed/ directory
echo -ne " \t[STEP 3.2] Creating destination directory"
mkdir -p "$PATH_to_compressed_fastq_files"
sleep 1
echo -ne "\r\033[K \t[STEP 3.2] Creating destination directory                [COMPLETED]\n"

#   3.3: Copy compressed files (loop)
echo -ne " \t[STEP 3.3] Copying compressed FASTQ files to destination"
for f in $PATH_to_raw_fastq_files/*.gz; do
    cp "$f" "$PATH_to_compressed_fastq_files"
done
sleep 1
echo -ne "\r\033[K \t[STEP 3.3] Copying compressed FASTQ files to destination [COMPLETED]\n"


# ==========================================================
#               STEP 4: Check MD5 integrity
# ==========================================================
sleep 2
echo " [STEP 4] Performing MD5 integrity check"

#   4.1: Navigate to compressed/
echo -ne " \t[STEP 4.1] Navigating to compressed/ directory"
cd "$PATH_to_compressed_fastq_files"
sleep 1
echo -ne "\r\033[K \t[STEP 4.1] Navigating to compressed/ directory           [COMPLETED]\n"

#   4.2: Run integrity check
echo -ne " \t[STEP 4.2] Run md5sum integrity check on compressed FASTQ\n\n"
md5sum -c ../$PATH_to_raw_fastq_files/$md5_checksum_file

echo -ne "\n[PIPELINE EXECUTION]: SUCCESSFUL\n"
