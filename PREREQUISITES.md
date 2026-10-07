# Course prerequisites: Programming & HPC systems

Please complete these steps **before** the course begins, to save time on installations. The process takes about 20–30 minutes.

You will need:

1. **VS Code** (code editor)
2. **Git** (version control)
3. A **terminal** with basic commands: `ls`, `md5sum`, `cp`, `mv`, `cat`

Instructions are given for **Windows**, **macOS** and **Linux**. Follow only the section for your operating system.

---

## 1. VS Code

Download it from https://code.visualstudio.com/download

| OS | What to download | How to install |
|---|---|---|
| **Windows** | *Windows* (User Installer) | Run the `.exe` and accept the defaults. Tick **"Add to PATH"** if asked. |
| **macOS** | *Mac Universal* (`.dmg`) | Open the file and drag **Visual Studio Code** into **Applications**. |
| **Linux** | *.deb* (Ubuntu/Debian) or *.rpm* (Fedora/RHEL) | `sudo apt install ./code_*.deb` or `sudo dnf install ./code-*.rpm` |

**Recommended extension:** open VS Code, go to the Extensions panel (`Ctrl+Shift+X`, or `Cmd+Shift+X` on Mac), search for **Remote - SSH** (by Microsoft) and install it. We will use it to connect to the HPC cluster.

---

## 2. Git

Full guide: https://github.com/git-guides/install-git

Follow the installation guide's instructions to check whether Git is already installed. Open a terminal (see Section 3) and run the following command:

```bash
git version
```

If you see a version number (e.g. `git version 2.43.0`), you're done. Otherwise, install it as follows:

### Windows
1. Download **Git for Windows** from https://git-scm.com/download/win
2. Run the installer and keep the default options.
3. This also installs **Git Bash**, the terminal we will use during the course (see section 3).

### macOS
Run `git version` in the **Terminal** app. If Git is missing, macOS will offer to install the **Command Line Developer Tools**. Click **Install** and wait for it to finish.

Alternatively, if you use Homebrew: `brew install git`

### Linux
- Ubuntu/Debian: `sudo apt update && sudo apt install git`
- Fedora: `sudo dnf install git`

---

## 3. Terminal and basic commands

During the course we will use these commands:

| Command | What it does |
|---|---|
| `ls` | List files in a directory |
| `cp` | Copy files |
| `mv` | Move or rename files |
| `cat` | Print a file's contents |
| `md5sum` | Compute a file's checksum (to verify file integrity) |

### Opening the terminal in VS Code
 
Everyone will work in the same place, whatever their OS: a **bash terminal inside VS Code**.
 
1. Open VS Code.
2. Go to **Terminal → New Terminal** (or press `` Ctrl+` ``). A terminal panel opens at the bottom of the window.
3. Make sure it is a **bash** terminal. Click the arrow next to the `+` button in the terminal panel and choose:
   - **Windows:** **Git Bash** (installed with Git in section 2). Don't use *PowerShell* or *Command Prompt*: they don't include these commands.
   - **macOS:** **bash** (the default is *zsh*).
   - **Linux:** **bash** (usually the default already).
4. To make bash open by default, use the same dropdown, choose **Select Default Profile**, and pick the option above.
### Checking the commands are available
 
In the VS Code bash terminal, run:
 
```bash
type ls cp mv cat md5sum git
```
 
Each command should print a line like `ls is /usr/bin/ls`. If any line says `not found`, that command is missing.
 
### macOS note on `md5sum`
macOS may not include `md5sum`. Check with:
 
```bash
md5sum --version
```
 
If it says `command not found`, use the built-in equivalent instead, which gives the same output format:
 
```bash
md5 -r myfile.txt
```
 
Alternatively, if you use Homebrew, `brew install coreutils` provides it as `gmd5sum`.
 
---
 
## 4. Final check
 
Open the bash terminal in VS Code (see section 3) and run these commands one by one. Each one should run **without** `command not found`:
 
```bash
git version
code --version
ssh -V
echo "hello" > test.txt
cat test.txt
cp test.txt test_copy.txt
mv test_copy.txt test_renamed.txt
ls
md5sum test.txt        # macOS: md5 -r test.txt
```
 
If everything works, you're ready for the course. You can delete the test files afterwards (`rm test.txt test_renamed.txt`).
 
> **macOS:** if `code --version` fails, open VS Code, press `Cmd+Shift+P`, type **"Shell Command: Install 'code' command in PATH"** and press Enter.
 
If you have any problem, please contact us **before** the course and include a screenshot of the error.
 