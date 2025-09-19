# Stepping-Stone Bioinformatics - Hands-on

Welcome! 🎉  
In this exercise you will practice some of the essential tools for bioinformatics:  

- **Bash/Linux** for file management
- **File compression** for storage and transfer optimiztion.
- **MD5 checksums** for data integrity  
- **Git & GitLab** for version control and collaboration (basic)

By the end, you will have compressed biological sequences files, transferred them into a new folder, verified their integrity, and tracked your work with git.

The only thing you will need is a unix terminal but we higly encourage you to use Visual Studio Code.

---

## 1. Get the Repository

### 1.1 Cloning from GitLab

The Research Computing Platform manages the [IDIBAPS' institutional GitLab](https://gitlab.com/frcb_idibaps)

Inside there are different groups and projects. One of them is the project of this seminar. If you are reading this you might have been invited to the following project: [Stepping Stone Hands On](https://gitlab.com/frcb_idibaps/rcp/resources/stepping-stone-hands-on)

If this is your case you should have a temporary username and password to be able to directly clone the repo in your system.

To do so, open the terminal (preferably in Visual Studio Code) in your system and type:

```bash
git clone https://gitlab.com/frcb_idibaps/rcp/resources/stepping-stone-hands-on.git
```

A new folder called stepping-stone-hands-on has been created.

(If you encounter any trouble cloning the repo we will provide it in a zipped folder.)

Use the cd command to move inside it.

```bash
cd stepping-stone-hands-on/
```

To be able to work with git version control (even locally) you need to set a minimum configuration. For this exercise we will set a repo-only configuration. In case you already worked with git globally in your system you won't need to run this step.

```bash
git config user.name "Seminar Student" # change it with your name
git config user.email "student@example.com" # change it with your institution email
```

### 1.2 Downloading a zipped version

In the [Stepping Stone Hands On](https://gitlab.com/frcb_idibaps/rcp/resources/stepping-stone-hands-on) page there is blue dropdown button called 'Code'. If you click it you could download a zipped version of this repository. Copy and extract it elsewhere in your system and move inside the folder called stepping-stone-hands-on-main

```bash
cd stepping-stone-hands-on-main/
```

When you download a repo with a zip you get its contents but you don't get the .git folder where all the commited changes are stored. So we need to initialize a new git repository. We will explain this commands more in detail later.

```bash
git init
git config user.name "Seminar Student" # change it with your name
git config user.email "student@example.com" # change it with your institution email
git add.
git commit -m "Initial commit."
```

## 2. Inspect the contents of the Repository

Get a list of its content in different ways:

```bash
ls
ls -l
ls -lh
tree
```

As you can see we have 2 folders and this README. The folder called data/ contains a list of fastq files and the folder scripts/ contains some bash scripts. The main goal of this exercise is to compress the fastq files and properly transfer them to another folder.

First we will create the destination folder inside the scripts/ directory. We will call it input_data.

```bash
mkdir scripts/input_data
```

Now move to the data/ directory, get the list of its content and print the first 16 lines of 01.fastq file in the terminal:

```bash
cd data/
ls -lh
head -n 16 01.fastq
```

❓ Based on the result of the following command,

```bash
pwd
```

What's the absolute and relative path of **01.fastq file**? What's the relative path of this **README**? (having in mind that you are in the data/ folder). 🤔

## 3. Compression of files

Inside the data/ directory use the gzip tool to compress the 01.fastq file.

```bash
gzip 01.fastq
```

Observe the newly generated file. Where is the original uncompressed file?

Unzip the recently compressed file again with gunzip:

```bash
gunzip 01.fastq.gz
```

We can keep the original uncompressed file adding the -k option:

```bash
gzip -k 01.fastq
```

Now you can compress the rest of the files using the * wildcard:

```bash
gzip *.fastq
```

The following message has been prompted in the terminal:

🖥️ `gzip: 01.fastq.gz already exists; do you wish to overwrite (y or n)?`

We can choose yes (y) or no (n). What would be the result depending on our answer? And if we used the -k option? 🤔

List the files and their corresponding info in a human-readable format to compare the size of them before and after compression.

```bash
ls -lh 
```

Take a look at 01.fastq and 01.fast.gz respective sizes. **425K vs. 75K**. The size has been dimished by almost 6 times. 💡

With gzip you can control the compression level with -1 to -9 options. But bear in mind that greater compression will take longer to finish. Default value is -6.

💻 `gzip -1 file.fastq   # very fast, larger file`

💻 `gzip -9 file.fastq   # slower, smaller file`

## 4. MD5 Checksum Generation

As we said earlier, our main goal 🎯 is to copy the compressed files to the input_data directory. Transfering large files between directories or different machines is a very common task in bioinformatics. Some biological datasets can be heavy in size reaching several GB or TB and problems might arise because of connection failures. Luckily there's a tool to check that the transfer has been done correctly and the copied files haven't been corrupted.

First we need to generate the md5sums in the origin directory:

```bash
md5sum *.fastq.gz > checksums.md5
cat checksums.md5
```

This creates a file called checksums.md5. It contains a unique 32-character alphanumeric string for each of the gzipped fastq files.

Now we can transfer the files from the origin to the destination folder.

```bash
cp *.fastq.gz ../scripts/input_data
```

🤔 Remember we are using ../ because our current working directory is still data/ so we need to go up one level before moving to scripts/ folder.

```bash
cd ../scripts/input_data
```

Now that we are inside input_data/ (the destination directory) we can check whether the transfer of the compressed files has been properly done.

```bash
md5sum -c ../../data/checksums.md5
```

This command calculates the md5 unique sequence for each file and compares them to the previously created in the origin folder. If any issue has happened during the transfer process and the resulting files got corrupted the md5 sequences wouldn't match with the originals.

## 5. Track Your Work with Git

Once you have finished the tasks, go back to the repository root:

```bash
cd ../..
```

To track the changes in the repo we can use the git status command:

```bash
git status
```

This tells us what files have been created or modified. Now we can decide which ones to load to the stage (which ones we want to track).

```bash
git add data/*.gz data/checksums.md5
```

Run the git status again to see the prgress.

```bash
git status
```

As you can see, we forgot to include the input_data/ folder and its content. Luckily we have the following command to add to the commit stage all the changes that have been done:

```bash
git add .
```

All the changes that we want to be tracked need to be associated with a descripive message summarizing what's been changed. This is done with the git commit:

```bash
git commit -m "Compressed FASTQ files, copied to input_data/ and verified its integrity."
```

Now imagine this was not part of a training seminar but a real world project. And you realize you made some mistake during the process. With git your can move through different commits and branches (we won't explain branches in detail here).

Every commit has its own ID. You can see it with:

```bash
git log --oneline
```

You will see something like:

🖥️ `a1b2c3d Compressed FASTQ files, copied to input_data/ and verified its integrity.`

🖥️ `789abcd  Initial commit.`

Now we can move back to the initial commit with:

```bash
git checkout 789abcd #change with your actual hash
```

Look at the repo structure again. You can do it with the tree command:

```bash
tree
```

We have moved back to the initial stage where only the fastq files are in the data/ directory.

## 6. Automatize the whole workflow in a script

In the scripts folder there's a couple bash scripts that automatize the whole proces in a single run.

Simply run the following command from the root directory of the repo.

```bash
sh scripts/script_1.sh
```

Now you can try the second script. Remeber to get back to the previous commit stage.

```bash
git checkout 789abcd #change with your actual hash
```

And do the same with the script_2.sh:

```bash
sh scripts/script_2.sh
```

Inspect the scripts. If you are working with Visual Stucio Code you can directly open the files. But from the terminal:

```bash
cat scripts/script_1.sh
cat scripts/script_2.sh
```

Both scripts are doing exactly the same process but using different syntax. Both ways are correct but are not the only ones to perform such a task.

We have seen a single tool for compressing files (gzip) but there are a lot more: tar, bgzip (speficic for vcf files), etc.

There are other ways to perform md5sum, for example to generate an md5 file for each one of the files to transfer instead of redirecting the results to a single file (> checksums.md5) and then transfering both (each file and their respective md5).

git is an extremely powerfull tool for version control. We have only seen a limited part of it. Also we haven't done any git push. GitHub or GitLab (as in our case) offer a wide range of possibilities for collaborative work.

Go out and explore. Open code is the best topic to learn by yourself.
