# FASTQ Compression, Transfer, and Integrity Check Script

## Overview

This repository provides a **Bash script** (`template.sh`) designed for
handling FASTQ files.\
The script automates the process of:

1.  **Compressing FASTQ files** (`.fastq`) using gzip (maximum
    compression).
2.  **Generating MD5 checksums** for compressed files.
3.  **Transferring compressed files** to a designated directory.
4.  **Validating file integrity** using the generated checksum.

This is particularly useful in bioinformatics workflows to ensure
efficient storage, transfer, and data integrity validation.

------------------------------------------------------------------------

## Author & Institution

-   **Author:** Your Name\
-   **Institution:** IDIBAPS\
-   **Core Facility:** Research Computing Platform\
-   **Date:** October 2025

------------------------------------------------------------------------

## Requirements

### Dependencies

The following tools must be installed and available in your system's
PATH:

-   `bash` (\>= 4.0)
-   `coreutils` (`ls`, `cp`, `mv`, `rm`, `cat`, `head`, `tail`)
-   `gzip` / `gunzip`
-   `md5sum`

Check versions with:

``` bash
bash --version
gzip --version
md5sum --version
```

------------------------------------------------------------------------

## Usage

### 1. Make the script executable

``` bash
chmod +x template.sh
```

### 2. Run the script

``` bash
./template.sh
```

### 3. Expected Workflow

1.  Navigate to the **starting directory**
    (`PATH_to_stepping_stone_hands_on`).
2.  Compress all `.fastq` files from the **raw/** directory (keeps
    originals).
3.  Generate an **MD5 checksum file** (`checksum.md5`).
4.  Move compressed files into a **compressed/** directory.
5.  Verify the integrity of the compressed files using MD5.

------------------------------------------------------------------------

## Variables to Configure

Before running, edit the script and provide absolute paths where needed:

-   `PATH_to_stepping_stone_hands_on` → Root working directory\
-   `PATH_to_raw_fastq_files` → Input FASTQ directory (default: `raw`)\
-   `PATH_to_compressed_fastq_files` → Output directory for compressed
    FASTQ files (default: `compressed`)\
-   `md5_checksum_file` → Name of MD5 checksum file (default:
    `checksum.md5`)

------------------------------------------------------------------------

## Example Directory Structure

    project_root/
    │
    ├── raw/                # Contains input FASTQ files (*.fastq)
    │   ├── sample1.fastq
    │   ├── sample2.fastq
    │
    ├── compressed/         # Will contain compressed files (*.fastq.gz)
    │
    ├── checksum.md5        # Checksum file for validation
    │
    └── template.sh         # The script

------------------------------------------------------------------------

## MD5 Integrity Check

To manually verify integrity later:

``` bash
cd compressed/
md5sum -c ../raw/checksum.md5
```

If successful, you should see:

    sample1.fastq.gz: OK
    sample2.fastq.gz: OK

------------------------------------------------------------------------

## Notes

-   The script **keeps original FASTQ files** in `raw/` and creates
    compressed copies.\
-   The checksum file is generated in the **raw/** directory and then
    used to validate files after transfer.\
-   Modify variables as needed for your environment.

------------------------------------------------------------------------

## License

This script is released under the **MIT License**.\
Feel free to adapt and reuse for research purposes.
