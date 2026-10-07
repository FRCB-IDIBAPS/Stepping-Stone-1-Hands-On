#!/usr/bin/env bash
# ==========================================================
# Institution:   IDIBAPS
# Core Facility: Research Computing Platform
# Date:          2025-10
#
# Script Name:   helpers.sh
# Purpose:       Error handling and progress messages for
#                the pipeline in template.sh
#
# Usage:         Not run directly: template.sh loads it
#                with the command  .  (also called source)
#
# Notes:
#   - You do NOT need to edit or understand this file to
#     complete the exercise. Read it when you are curious!
#   - In short:
#       * The pipeline STOPS at the first command that
#         fails and tells you the task and the line where
#         it happened
#       * step / task / finish print the progress messages
#       * gzip, md5sum and cp are run one file at a time,
#         so a progress bar can be drawn while they work.
#         In template.sh you still write these commands
#         exactly as you would in the terminal
# ==========================================================




#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   1: The pipeline needs bash (not sh)
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if [ -z "${BASH_VERSION:-}" ]; then
    echo "ERROR: run this script with bash, like this:  bash src/template.sh" >&2
    exit 1
fi
if [ "$(basename "$0")" = "helpers.sh" ]; then
    echo "helpers.sh does nothing by itself. Run the pipeline:  bash src/template.sh" >&2
    exit 1
fi

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   2: Stop at the first error instead of carrying on
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
set -o errexit      # Stop when a command fails
set -o nounset      # Stop when a variable that does not exist is used
set -o pipefail     # A chain of commands (cmd1 | cmd2) fails if any of them fails
set -o errtrace     # Report errors that happen inside the functions below too

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   3: Where and how to print messages
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Channel 3 is a copy of the screen: progress messages still
# reach it when a command's output is redirected to a file (>)
exec 3>&1

# Seconds to wait after each file, so the progress bar can be seen
# (our FASTQ files are tiny). Try:  PROGRESS_PAUSE=0 bash src/template.sh
PROGRESS_PAUSE=${PROGRESS_PAUSE:-0.2}

# Full PATH to the pipeline script (the one that loaded this file):
# needed to show you the line that failed
_script=$(builtin cd "$(dirname "$0")" && pwd)/$(basename "$0")

# Animated bar and colours only when writing to a terminal. If the
# output goes to a file (bash src/template.sh > log.txt), plain
# lines are printed instead
_live=no; _green=""; _red=""; _reset=""; _columns=80
if [ -t 3 ] && [ "${TERM:-dumb}" != "dumb" ]; then
    _live=yes
    _columns=$(tput cols 2> /dev/null || echo 80)
    if [ -z "${NO_COLOR:-}" ]; then
        _green=$'\033[32m'; _red=$'\033[31m'; _reset=$'\033[0m'
    fi
fi

# What the script is doing right now
_task_id=""; _task_title=""; _task_open=no; _task_files=0
_bar_open=no; _reported=no

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   4: Progress messages
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# _bar 2 4   ->   [#####-----] 2/4
_bar() {
    local width=10 filled=$(( $1 * 10 / $2 )) bar="" i
    for (( i = 0; i < width; i++ )); do
        if (( i < filled )); then bar+="#"; else bar+="-"; fi
    done
    printf '[%s] %d/%d' "$bar" "$1" "$2"
}

# _progress DONE TOTAL NEXT-FILE: draw the bar of the current task
_progress() {
    local line
    _task_files=$2
    if [ "$_live" = yes ]; then
        # \r goes back to the start of the line and \033[K clears it, so
        # the bar is redrawn in place. The line is cut to the width of the
        # terminal because a line that wraps cannot be redrawn
        if [ "$_columns" -ge 76 ]; then
            line=$(printf '    [%s] %-34s %-11s  %s  %s' "$_task_id" "$_task_title" "[RUNNING]" "$(_bar "$1" "$2")" "$3")
        else    # Narrow terminal: the bar goes first, so it is never cut
            line=$(printf '    [%s] %s  %s' "$_task_id" "$(_bar "$1" "$2")" "$_task_title")
        fi
        printf '\r%s\033[K' "${line:0:$(( _columns - 1 ))}" >&3
        _bar_open=yes
    elif [ -n "$3" ]; then
        printf '    [%s] %s: file %d/%d  %s\n' "$_task_id" "$_task_title" "$(( $1 + 1 ))" "$2" "$3" >&3
    fi
}

# Finish the line of the bar, so that the next message starts on a new line
_end_bar() {
    if [ "$_bar_open" = yes ]; then printf '\n' >&3; _bar_open=no; fi
}

# _close_task COMPLETED|FAILED: print the final line of the current task
_close_task() {
    local colour=$_green extra=""
    [ "$_task_open" = yes ] || return 0
    [ "$1" = COMPLETED ] || colour=$_red
    if [ "$1" = COMPLETED ] && [ "$_task_files" -gt 0 ]; then
        extra="  $(_bar "$_task_files" "$_task_files")"
    fi
    if [ "$_bar_open" = yes ]; then printf '\r\033[K' >&3; _bar_open=no; fi
    printf '    [%s] %-34s %s%s%s%s\n' "$_task_id" "$_task_title" "$colour" "[$1]" "$_reset" "$extra" >&3
    _task_open=no
}

# step NUMBER "TITLE": announce a new STEP of the pipeline
step() {
    _close_task COMPLETED
    printf '\n [STEP %s] %s\n' "$1" "$2" >&3
}

# task NUMBER "TITLE": announce a new task. The task is reported as
# [COMPLETED] when the next task starts, or as [FAILED] if a command fails
task() {
    local unfinished='^[[:space:]]*[A-Za-z0-9_]+[[:space:]]*#[[:space:]]*\[INSERT-CODE-HERE\]'
    local next number
    _close_task COMPLETED
    _task_id=$1; _task_title=$2; _task_files=0; _task_open=yes
    # Look at the first line of code after this one: is it still to be completed?
    next=$(tail -n "+$(( BASH_LINENO[0] + 1 ))" "$_script" | grep -n -m 1 -v -E '^[[:space:]]*(#|$)' || true)
    if [[ ${next#*:} =~ $unfinished ]]; then
        number=$(( BASH_LINENO[0] + ${next%%:*} ))
        _fail "$number" \
            "This line of code is not finished yet." \
            "Replace the comment  # [INSERT-CODE-HERE]  with the missing argument/s" \
            "(read the 'Must include' notes above that line), save the file and" \
            "run the script again."
    fi
}

# finish: last message of a pipeline that worked
finish() {
    _close_task COMPLETED
    _reported=yes
    printf '\n [PIPELINE EXECUTION]: %sSUCCESSFUL%s\n' "$_green" "$_reset" >&3
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   5: Error messages
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# _fail LINE-NUMBER "MESSAGE"...: explain what went wrong and stop
_fail() {
    local number=$1 message
    shift
    _reported=yes
    _end_bar
    _close_task FAILED
    {
        printf '\n ERROR in task %s, line %s of %s:\n\n' "${_task_id:-?}" "$number" "$(basename "$_script")"
        printf '     %s\n\n' "$(sed -n "${number}p" "$_script")"
        for message in "$@"; do printf ' %s\n' "$message"; done
        printf '\n [PIPELINE EXECUTION]: %sFAILED%s\n' "$_red" "$_reset"
    } >&2
    exit 1
}

# Runs by itself every time a command fails (see "trap" below)
_on_error() {
    local status=$1 hint=()
    # Line of THIS script where the failing command was written
    local number=${BASH_LINENO[$(( ${#BASH_LINENO[@]} - 2 ))]}
    if [ "$status" -eq 126 ] || [ "$status" -eq 127 ]; then
        hint=("Hint: bash did not find a command it can run in this line. Look for" "typos, and for spaces around '=' when a variable is defined.")
    fi
    _fail "$number" \
        "The command in this line failed (exit status $status)." \
        "Read the message printed just above this one, correct the line," \
        "save the file and run the script again." ${hint[@]+"${hint[@]}"}
}

# Safety net: never stop with an error without saying so
_on_exit() {
    local status=$?
    if [ "$status" -ne 0 ] && [ "$_reported" = no ]; then
        _end_bar
        _close_task FAILED
        printf '\n [PIPELINE EXECUTION]: %sFAILED%s \n' "$_red" "$_reset" >&2
        printf ' Read the message printed above: it has the line number and the reason.\n' >&2
    fi
}

# Runs when you press Ctrl+C
_on_interrupt() {
    _reported=yes
    _end_bar
    printf '\n [PIPELINE EXECUTION]: %sINTERRUPTED%s\n' "$_red" "$_reset" >&2
    exit 130
}

trap '_on_error $?' ERR
trap '_on_exit' EXIT
trap '_on_interrupt' INT    # Ctrl+C

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   6: Check that the workshop directory is correct
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
check_workshop_directory() {
    local dir=${PATH_to_stepping_stone_hands_on:-} number problem=""
    number=$(grep -n -m 1 '^PATH_to_stepping_stone_hands_on=' "$_script" | cut -d : -f 1)
    if [ -z "$dir" ]; then
        problem="The variable PATH_to_stepping_stone_hands_on is empty."
    elif [ "${dir:0:1}" != "/" ]; then
        problem="'$dir' is not an absolute PATH: it must start with /"
    elif [ ! -d "$dir" ]; then
        problem="The directory '$dir' does not exist. Is there a typo?"
    elif ! ls "$dir"/raw/*.fastq > /dev/null 2>&1; then
        problem="'$dir' exists, but it has no raw/ directory with FASTQ files in it."
    fi
    [ -n "$problem" ] || return 0
    _fail "${number:-0}" "$problem" \
        "Write the absolute PATH to your stepping-stone-hands-on directory right" \
        "after the '=' (no spaces around '='). To find it, open a terminal in that" \
        "directory, run  pwd  and copy the output."
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   7: Commands with extra checks and a progress bar
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Inside the pipeline cd, gzip, md5sum and cp are the functions
# below. Each of them calls the real command with the arguments
# YOU wrote ("command gzip" means "the real gzip")

# _each_file COMMAND N ARGUMENTS...: run COMMAND once per file,
# drawing the progress bar. N=1 when the last argument is not an
# input file but the destination (cp)
_each_file() {
    local name=$1 has_destination=$2 options=() files=() destination=() argument total output i=0
    shift 2
    for argument in "$@"; do
        case $argument in
            -*) options+=("$argument") ;;
            *)  files+=("$argument") ;;
        esac
    done
    total=${#files[@]}
    if [ "$has_destination" -eq 1 ]; then
        # Anything that is not "cp FILE... DIRECTORY" is left to the real command
        if [ "$total" -lt 2 ] || [ ! -d "${files[$(( total - 1 ))]}" ]; then
            command "$name" "$@"
            return
        fi
        total=$(( total - 1 ))
        destination=("${files[$total]}")
        unset "files[$total]"
    fi
    if [ "$total" -eq 0 ]; then
        echo "$name: no file was given. Which files should $name work on?" >&2
        return 1
    fi
    for argument in "${files[@]}"; do
        if [ ! -e "$argument" ]; then
            case $argument in
                *[*?]*) echo "$name: the wildcard  $argument  does not match any file (current directory: $(pwd))" >&2 ;;
                *)      echo "$name: the file  $argument  does not exist (current directory: $(pwd))" >&2 ;;
            esac
            return 1
        fi
    done
    for argument in "${files[@]}"; do
        _progress "$i" "$total" "$argument"
        # Run the real command. Its error messages are kept in $output, to
        # print them on a clean line; its normal output goes where you sent it.
        # (the odd ${x[@]+"${x[@]}"} is "all the items of x, if there are any")
        if ! { output=$(command "$name" ${options[@]+"${options[@]}"} "$argument" ${destination[@]+"${destination[@]}"} 2>&1 1>&4); } 4>&1; then
            _end_bar
            printf '%s\n' "$output" >&2
            return 1
        fi
        if [ -n "$output" ]; then _end_bar; printf '%s\n' "$output" >&2; fi
        i=$(( i + 1 ))
        if [ "$_live" = yes ]; then sleep "$PROGRESS_PAUSE"; fi
    done
    _progress "$total" "$total" ""
}

# cd: a "cd" with no directory would silently send us to our home directory
cd() {
    if [ $# -eq 0 ]; then
        echo "cd: no directory was given. Where should we go?" >&2
        return 1
    fi
    builtin cd "$@"
}

# gzip: -f overwrites the .gz files of a previous run. Without it gzip
# would stop to ask "do you wish to overwrite (y or n)?" for every file
gzip() {
    _each_file gzip 0 -f "$@"
}

# cp: one file at a time
cp() {
    _each_file cp 1 "$@"
}

# md5sum: hashes one file at a time. With -c (check) it runs just once,
# because it already prints one line per file
md5sum() {
    local argument
    for argument in "$@"; do
        case $argument in
            --check|-c|-[!-]*c*)
                if ! command md5sum "$@" | sed 's/^/          /'; then
                    echo "md5sum: the check did not pass, every file must be reported as OK." >&2
                    echo "        FAILED = the file is not identical to the one that was hashed." >&2
                    echo "        No such file = the PATH to the .md5 file (or to a file listed in it) is wrong." >&2
                    return 1
                fi
                return 0 ;;
        esac
    done
    _each_file md5sum 0 "$@"
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   8: Check dependencies and say hello
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
for _tool in gzip md5sum cp mkdir grep sed tail; do
    if ! type -P "$_tool" > /dev/null; then
        _reported=yes
        echo "ERROR: the command '$_tool' is not installed on this computer." >&2
        exit 1
    fi
done

echo "-----------------------------------------------------" >&3
echo " STEPPING-STONE: BIODATASERIES 1"                       >&3
echo " FASTQ compression and transfer pipeline"               >&3
echo "-----------------------------------------------------" >&3
