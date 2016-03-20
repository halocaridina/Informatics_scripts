#!/bin/bash

### This script should be easy to follow below

READS1=$1
READS2=$2
ANALYZE=`which prinseq-lite.pl`
GRAPH=`which prinseq-graphs-noPCA.pl`
DYMTHYR=`date | awk '{print ($3$2$6)}'`

if [ $# == 1 ]; then
  $ANALYZE -verbose -fastq $READS1 -graph_data ${READS1}_${DYMTHYR}.gd -out_good null -out_bad null
  $GRAPH -i ${READS1}_${DYMTHYR}.gd -html_all -o ${READS1}_PRINSEQ_ANALYSIS_${DYMTHYR} && rm -f ${READS1}_${DYMTHYR}.gd
  exit
elif [ $# == 2 ]; then
  $ANALYZE -verbose -fastq $READS1 -fastq2 $READS2 -graph_data ${READS1}_${READS2}_${DYMTHYR}.gd -out_good null -out_bad null
  $GRAPH -i ${READS1}_${READS2}_${DYMTHYR}.gd -html_all -o ${READS1}_${READS2}_PRINSEQ_ANALYSIS_${DYMTHYR} && rm -f ${READS1}_${READS2}_${DYMTHYR}.gd
  exit
else
  echo "Usage: $0 READS1.fq [READS2.fq (if PE)]"
  exit
fi

