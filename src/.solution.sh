#!/usr/bin/env bash
# ==========================================================
# Author:        Your Name
# Institution:   IDIBAPS
# Core Facility: Research Computing Platform
# Date:          2025-10
#
# Script Name:   template.sh
# Purpose:       Performs FASTQ compression, file transfer
#                and file integrity check afterwards
#
# Usage:         sh template.sh
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
#   0.1: Define workshop directory
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
PATH_to_stepping_stone_hands_on= #[INSERT-ABSOLUTE-PATH-TO-STEPPING-STONE-HANDS-ON]
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if [ -z "$PATH_to_stepping_stone_hands_on" ]; then
    echo -ne "\r\033[K [STEP 0] Moving to workshop directory                           [FAILED]\n"
    echo -ne "\r\033[K          CAUSE: Failed to define a valid workshop directory\n"
  exit 1
fi
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cd $PATH_to_stepping_stone_hands_on
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
sleep 1
echo -ne "\r\033[K [STEP 0] Moving to workshop directory                           [COMPLETED]\n"



# ==========================================================
#               STEP 1: Compress FASTQ file/s
# ==========================================================
sleep 2
echo " [STEP 1] Compressing FASTQ files from raw/ directory"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Variables needed for this STEP:
PATH_to_raw_fastq_files=raw


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   1.1: Navigate to directory with raw FASTQ files
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo -ne " \t[STEP 1.1] Navigating to raw/ directory"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Must include:
#       - Variable with PATH to raw directory
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cd $PATH_to_raw_fastq_files
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
sleep 1
echo -ne "\r\033[K \t[STEP 1.1] Navigating to raw/ directory                  [COMPLETED]\n"


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   1.2: Compress FASTQ files 
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo -ne " \t[STEP 1.2] Compressing FASTQ files"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Must include:
#       - Keep original FASTQ files
#       - Compress using max compression (slowest)
#       - Wildcard that matches ALL FASTQ files
#         in directory
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
gzip -k9 *.fastq
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
sleep 1
echo -ne "\r\033[K \t[STEP 1.2] Compressing FASTQ files                       [COMPLETED]\n"



# ==========================================================
#               STEP 2: Hash FASTQ (.gz) file/s
# ==========================================================
sleep 2
echo " [STEP 2] Hashing FASTQ files"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Variables needed for this STEP:
md5_checksum_file=checksum.md5


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   2.1: Hash FASTQ files and redirect output to .md5 file 
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo -ne " \t[STEP 2.1] Storing all FASTQ hash in .md5 file"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Must include:
#       - Wildcard that matches ALL COMPRESSED FASTQ files
#         in directory
#       - Output redirection: dump stdout to our .md5 file
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
md5sum *.gz > $md5_checksum_file
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
sleep 1
echo -ne "\r\033[K \t[STEP 2.1] Storing all FASTQ hash in .md5 file           [COMPLETED]\n"



# ==========================================================
#               STEP 3: Transfer FASTQ file/s
# ==========================================================
sleep 2
echo " [STEP 3] Transferring FASTQ files"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Variables needed for this STEP:
PATH_to_raw_fastq_files=raw
PATH_to_compressed_fastq_files=compressed


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   3.1: Navigate to initial directory      [FREE TASK]
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo -ne " \t[STEP 3.1] Navigating to workshop directory"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Must include:
#       - Variable with PATH to Stepping Stone Hands on
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cd $PATH_to_stepping_stone_hands_on
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
sleep 1
echo -ne "\r\033[K \t[STEP 3.1] Navigating to workshop directory              [COMPLETED]\n"


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   3.2: Create compressed/ directory
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo -ne " \t[STEP 3.2] Creating destination directory"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Must include:
#       - Check if directory already exists
#       - Variable with PATH to compressed directory
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
mkdir -p $PATH_to_compressed_fastq_files
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
sleep 1
echo -ne "\r\033[K \t[STEP 3.2] Creating destination directory                [COMPLETED]\n"


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   3.3: Copy compressed FASTQ files to compressed/
#        directory 
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo -ne " \t[STEP 3.3] Copying compressed FASTQ files to destination"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Must include:
#       - Variable with PATH to raw directory
#       - Wildcard that matches ALL COMPRESSED FASTQ files
#         in raw directory
#       - Variable with PATH to compressed directory
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cp $PATH_to_raw_fastq_files/*.gz $PATH_to_compressed_fastq_files
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
sleep 1
echo -ne "\r\033[K \t[STEP 3.3] Copying compressed FASTQ files to destination [COMPLETED]\n"



# ==========================================================
#               STEP 4: Check MD5 integrity
# ==========================================================
sleep 2
echo " [STEP 4] Performing MD5 integrity check"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Variables needed for this STEP:
PATH_to_raw_fastq_files=raw
PATH_to_compressed_fastq_files=compressed
md5_checksum_file=checksum.md5

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   4.1: Navigate to directory with compressed FASTQ files
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo -ne " \t[STEP 4.1] Navigating to compressed/ directory"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Must include:
#       - Variable with PATH to compressed directory
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cd $PATH_to_compressed_fastq_files
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
sleep 1
echo -ne "\r\033[K \t[STEP 4.1] Navigating to compressed/ directory           [COMPLETED]\n"


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   4.2: Perform MD5 check
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo -ne " \t[STEP 4.2] Run md5sum integrity check on compressed FASTQ\n\n"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Must include:
#       - Check file integrity with md5sum command
#       - Variable with PATH to raw directory
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
md5sum -c ../$PATH_to_raw_fastq_files/$md5_checksum_file
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
echo -ne "\n[PIPELINE EXECUTION]: SUCCESSFUL\n"
