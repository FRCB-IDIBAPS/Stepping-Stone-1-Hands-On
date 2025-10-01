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




# ==========================================================
#               STEP 0: Navigate to starting directory
# ==========================================================
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   0.1: Define workshop directory
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
PATH_to_stepping_stone_hands_on= #[INSERT-ABSOLUTE-PATH-TO-STEPPING-STONE-HANDS-ON]
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cd $PATH_to_stepping_stone_hands_on




# ==========================================================
#               STEP 1: Compress FASTQ file/s
# ==========================================================
# Variables needed for this STEP:
PATH_to_raw_fastq_files=raw

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   1.1: Navigate to directory with raw FASTQ files
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Must include:
#       - Variable with PATH to raw directory
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cd $PATH_to_raw_fastq_files

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   1.2: Compress FASTQ files 
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Must include:
#       - Keep original FASTQ files
#       - Compress using max compression (slowest)
#       - Wildcard that matches ALL FASTQ files
#         in directory
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
gzip -k9 *.fastq

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~




# ==========================================================
#               STEP 2: Hash FASTQ (.gz) file/s
# ==========================================================
# Variables needed for this STEP:
md5_checksum_file=checksum.md5

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   2.1: Hash FASTQ files and redirect output to .md5 file 
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Must include:
#       - Wildcard that matches ALL COMPRESSED FASTQ files
#         in directory
#       - Output redirection: dump stdout to our .md5 file
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
md5sum *.gz > $md5_checksum_file

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~




# ==========================================================
#               STEP 3: Transfer FASTQ file/s
# ==========================================================
# Variables needed for this STEP:
PATH_to_raw_fastq_files=raw
PATH_to_compressed_fastq_files=compressed

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   3.1: Navigate to initial directory      [FREE TASK]
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Must include:
#       - Variable with PATH to Stepping Stone Hands on
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cd $PATH_to_stepping_stone_hands_on

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   3.2: Create compressed/ directory
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Must include:
#       - Check if directory already exists
#       - Variable with PATH to compressed directory
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
mkdir -p $PATH_to_compressed_fastq_files

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   3.3: Copy compressed FASTQ files to compressed/
#        directory 
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Must include:
#       - Variable with PATH to raw directory
#       - Wildcard that matches ALL COMPRESSED FASTQ files
#         in raw directory
#       - Variable with PATH to compressed directory
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cp $PATH_to_raw_fastq_files/*.gz $PATH_to_compressed_fastq_files

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~




# ==========================================================
#               STEP 4: Check MD5 integrity
# ==========================================================
# Variables needed for this STEP:
PATH_to_raw_fastq_files=raw
PATH_to_compressed_fastq_files=compressed
md5_checksum_file=checksum.md5

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   4.1: Navigate to directory with compressed FASTQ files
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Must include:
#       - Variable with PATH to compressed directory
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cd $PATH_to_compressed_fastq_files

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   4.2: Perform MD5 check
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Must include:
#       - Check file integrity with md5sum command
#       - Variable with PATH to raw directory
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
md5sum -c $PATH_to_raw_fastq_files/$md5_checksum_file
