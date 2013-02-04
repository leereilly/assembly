#!/bin/bash

set -e

# export ARASTURL=140.221.84.124
export PATH=/kb/deployment/bin:$PATH

TEST_DIR="test_${$}"

function message {
    echo
    echo
    echo
    echo
    echo "##########################"
    echo "#"
    echo "# $1"
    echo "#"
    echo "##########################"
    echo
    echo
    echo
    echo
}


message "Login with Tester's ID"
ar_login

message "Check queue status"
# arast -s $ARASTURL stat
ar_stat

message "Download synthetic metagenome (200MB)"
rm -f smg.fa
# curl -OL http://www.mcs.anl.gov/~fangfang/test/smg.fa
wget http://www.mcs.anl.gov/~fangfang/test/smg.fa

message "Submit synthetic  metagenome for kiki assembly and bwa mapping validation"
# export jobid=`arast -s $ARASTURL run -a kiki -f smg.fa --bwa`
export jobid=`ar_run -a kiki -f smg.fa --bwa`
echo "Job id = $jobid"

message "Check job status"
sleep 2
# arast -s $ARASTURL stat
ar_stat
sleep 5

message "Check random data status"
# arast -s $ARASTURL stat --data 1
ar_stat --data 1
sleep 5

message "Wait 90s for job to finish and download results"
sleep 90

message "Check job status again"
sleep 2
# arast -s $ARASTURL stat
ar_stat
sleep 3

# arast -s $ARASTURL get -j $jobid
ar_get -j $jobid

message "Tests Complete: PASSED"
