#!/bin/sh

#  CommitTrackerTotals.sh
#  Shows all commits
#  Created by Larry McLister on 2/22/12.

# Assemble date+time
    mydate=$(date +%Y.%m.%d)
    mydate=${mydate%% }
    mydate=${mydate## }

    mytime=$(date +%k.%M)
    mytime=${mytime%% }
    mytime=${mytime## }

    now=$mydate.$mytime

# Assemble log file names
    gitLogByAuthor=total_commits_commit.txt
    gitLogByPatch=total_commits_patch.txt
    gitLogByReview=total_commits_review.txt

# Set root directory for results.
    read -p "$resultsroot" -p "Please enter root directory for results: " resultsroot
    resultsroot="${resultsroot:-/Users/lmcliste/code/commit-tracker/results}"
    # echo $resultsroot

    store=$resultsroot/$now

# Set WebKit home dir
    read -p "$webkithome" -p "Please enter WebKit root directory: " webkithome
    webkithome="${webkithome:-/Users/lmcliste/code/WebKit}"
    # echo $webkithome

# Make dir for results
    echo changing to results root directory... $resultsroot
    cd $resultsroot
    echo making results directory... $now
    mkdir $now

# Switch to the WebKit dir in prep for fetch
    echo changing to WebKit home directory...
    cd $webkithome
    echo "Executing in $PWD."
    echo "Logs will be written to $store."

# Test to see if we have SSH connection (coming soon?)

# Get latest src from WebKit Git
    echo starting git fetch...
    git fetch origin

# Rebase
    echo starting rebase...
    git rebase origin/master

# TODO output csv 

# Search for commits where we are the Author/Committer
    echo "looking for 'Author:'..."
    git log | grep "^[\\t ]*Author: " | sed "s/ <.*//; s/ *//; s/^[\\t ]*Author: //" | sort | uniq -c | sort -nr  | egrep 'mihnea@adobe.com|achicu@adobe.com|krit@webkit.org' > $store/$gitLogByAuthor

# Search for commits where we created reviewed the patch
    echo "looking for 'Reviewed by'..."
    git log | grep "^[\\t ]*Reviewed by " | sed 's/ <.*//; s/\\t*//; s/ *//; s/^[\\t ]*Reviewed by //' | sort | uniq -c | sort -nr  | egrep 'Bear Travis|Mihnea|Chiculita|Raul Hudea|Max Vujovic|Hans Muller|Ethan Malasky|Arno Gourdol|Alan Stearns|Larry McLister|Jacob Goldstein|Dirk Schulze|Rebecca Hauck|Flex Mobile|David Alcala|Victor Carbune|Mihai Balan' > $store/$gitLogByReview

# Search for commits where we created the patch
    echo "looking for 'Patch by'..."
    git log | grep "^[\\t ]*Patch by " | sed 's/ <.*//; s/\\t*//; s/ *//; s/^[\\t ]*Patch by //' | sort | uniq -c | sort -nr  | egrep 'Bear Travis|Mihnea|Chiculita|Raul Hudea|Max Vujovic|Hans Muller|Ethan Malasky|Arno Gourdol|Alan Stearns|Larry McLister|Jacob Goldstein|Dirk Schulze|Rebecca Hauck|Flex Mobile|David Alcala|Victor Carbune|Mihai Balan' > $store/$gitLogByPatch

    open $store