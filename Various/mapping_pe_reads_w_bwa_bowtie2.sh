#!/bin/bash

<<<<<<< HEAD
## WORKING INSTALLS OF BWA 0.7.7-r441, SAMTOOLS 0.1.19 AND BOWTIE2-2.2.0 (PLUS THEIR SUPPLEMENTARY TOOLS/SCRIPTS) ARE NEEDED BY THIS SCRIPT

## Written by S.R. Santos, Department of Biological Sciences, Auburn University, Auburn, AL 36849 ###
## CHANGE LOG: 										   ###
## Sep 29th, 2012	v1.0: initial creation							   ###
## Oct 6th, 2012	v1.1: add options for exporting consensus sequence(s) from bwa in fasta	   ###
## Oct 8th, 2012	v1.2: add options for mapping using bowtie2
## Mar 10th, 2014	v1.3: code rewite of particular sections

## SET UP THE WORKING ENVIRONMENT ###
=======
### WORKING INSTALLS OF BWA 0.6.2, SAMTOOLS 0.1.18 AND BOWTIE2-2.0.0-beta7 (PLUS THEIR SUPPLEMENTARY TOOLS/SCRIPTS) ARE NEEDED BY THIS SCRIPT

### Written by S.R. Santos, Department of Biological Sciences, Auburn University, Auburn, AL 36849 ###
### CHANGE LOG: 										   ###
### Sept 29th, 2012	v1.0: initial creation							   ###
### Oct 6th, 2012	v1.1: add options for exporting consensus sequence(s) from bwa in fasta	   ###
### Oct 8th, 2012	v1.2: add options for mapping using bowtie2
### Mar 10th, 2014	v1.3: code rewite of particular sections

### SET UP THE WORKING ENVIRONMENT ###
>>>>>>> refs/remotes/origin/master

export PATH=${PATH}

BWA=`which bwa`
SAMTOOLS=`which samtools`
BCFTOOLS=`which bcftools`
VCFUTILS=`which vcfutils.pl`
BT2=`which bowtie2`
BT_BUILD=`which bowtie2-build`
TDSTAMP=`date | awk 'OFS="_" {print ($2,$3,$6,$4)}'`
PWD=`pwd`

printf "*************************************************************************\n"
printf "*	 Map raw PE reads to scaffold(s) with BWA or BOWTIE2		*\n"
printf "*	 Gunzip FASTQ files and concat into single S1 and S2		*\n"
printf "*	   Script will work on individual .fastq.gz files	        *\n"
printf "*************************************************************************\n"

### ASK WHICH MAPPING SOFTWARE TO USE ###

printf '\nConduct the mapping with "bwa" or "bowtie2"?  '
read MAPPER

### BOMB OUT HERE IF BWA OR BOWTIE2 ARE NOT CALLED ###

if test ! $MAPPER = bwa ; then
    if test ! $MAPPER = bowtie2 ; then
        printf "\nI'm not sure what mapper you want so I'm outta here!!!\n\n"
        exit 192
    fi
fi

### HERE IS THE MAPPING USING BWA ###

if test $MAPPER = bwa ; then

printf '\nbwa selected\n'
printf '\nWhat is the name of the scaffold FASTA input file?  '
read SCAFFOLD_INPUT_FILE

if test ! -f $SCAFFOLD_INPUT_FILE ; then
  printf "\nNo matching file name!!!  Aborting!!!\n\n"
  exit 192
fi

printf '\nWhat is the name of the S1 FASTQ input file?  '
read S1_FASTQ_INPUT_FILE

if test ! -f $S1_FASTQ_INPUT_FILE ; then
  printf "\nNo matching file name!!!  Aborting!!!\n\n"
  exit 192
fi

printf '\nWhat is the name of the S2 FASTQ input file?  '
read S2_FASTQ_INPUT_FILE

if test ! -f $S2_FASTQ_INPUT_FILE ; then
  printf "\nNo matching file name!!!  Aborting!!!\n\n"
  exit 192
fi

printf "\nWhat will be the name for the SAM and BAM files?  "
read SAM_BAM_FILE

printf '\nWhat is name for the directory where final mapping files should be placed?  '
read FINAL_INDEX_DIR

if test ! -d $FINAL_INDEX_DIR ; then
  mkdir -p ${FINAL_INDEX_DIR}_bwa
fi

printf '\nHow many CPUs/threads do you want to use (not more than 20 - may I suggest 7 or 8)?  '
read NUM_CPU

if test $NUM_CPU -ge 20 ; then
  printf "\nUsing 20 or more CPUs can produce strange results with BWA!!!  Aborting!!!\n\n"
  rm -rdf ${FINAL_INDEX_DIR}_bwa
  exit 192
fi

printf '\nWhat quality cut-off would you like to use (depends on data - may I suggest a minimal of 20)?  '
read QUALITY

if test $QUALITY -lt 20 ; then
  printf "\nUsing a quality cut-off less than 20 isn't recommended!!!  You've been warned!!!\n"
fi

printf '\nWhat PE insert size would you like to use (depends on data - for HA PE data up to 10/2012, this is 600)?  '
read INSERT_SIZE

### LET THE MAPPING BEGIN WITH BWA!!! ###

${BWA} index ${SCAFFOLD_INPUT_FILE}
${BWA} aln -t ${NUM_CPU} -q ${QUALITY} -f ${PWD}/s1_1.aln ${SCAFFOLD_INPUT_FILE} ${S1_FASTQ_INPUT_FILE}
${BWA} aln -t ${NUM_CPU} -q ${QUALITY} -f ${PWD}/s2_1.aln ${SCAFFOLD_INPUT_FILE} ${S2_FASTQ_INPUT_FILE}
${BWA} sampe -P -a ${INSERT_SIZE} -f ${PWD}/${SAM_BAM_FILE}_alignment.sam ${SCAFFOLD_INPUT_FILE} ${PWD}/s1_1.aln ${PWD}/s2_1.aln ${S1_FASTQ_INPUT_FILE} ${S2_FASTQ_INPUT_FILE}
${SAMTOOLS} view -bS -T ${SCAFFOLD_INPUT_FILE} ${PWD}/${SAM_BAM_FILE}_alignment.sam > ${PWD}/${SAM_BAM_FILE}_alignment.bam
${SAMTOOLS} sort ${PWD}/${SAM_BAM_FILE}_alignment.bam ${PWD}/${SAM_BAM_FILE}_bwa_alignment_sorted
${SAMTOOLS} index ${PWD}/${SAM_BAM_FILE}_bwa_alignment_sorted.bam
mkdir ${FINAL_INDEX_DIR}_bwa/for_visualization

### SOME BASIC HOUSEKEEPING AND RM OF BWA FILES THAT ARE NO LONGER NEEDED ###

cp ${SCAFFOLD_INPUT_FILE} ${FINAL_INDEX_DIR}_bwa/for_visualization
mv ${PWD}/${SAM_BAM_FILE}_bwa_alignment_sorted.bam ${PWD}/${SAM_BAM_FILE}_bwa_alignment_sorted.bam.bai ${FINAL_INDEX_DIR}_bwa/for_visualization
mv ${FINAL_INDEX_DIR}_bwa/for_visualization ${FINAL_INDEX_DIR}_bwa/for_visualization_${TDSTAMP}
rm -f ${PWD}/*.a* ${PWD}/*.bwt ${PWD}/*.fai ${PWD}/*.pac ${PWD}/*.sa ${PWD}/*.aln ${PWD}/*.[sb]am

fi

### HERE IS THE MAPPING USING BOWTIE2 ###

if test $MAPPER = bowtie2 ; then

printf '\nbowtie2 selected\n'
printf '\nWhat is the name of the scaffold FASTA input file?  '
read SCAFFOLD_INPUT_FILE

if test ! -f $SCAFFOLD_INPUT_FILE ; then
  printf "\nNo matching file name!!!  Aborting!!!\n\n"
  exit 192
fi

printf '\nWhat is the name of the S1 FASTQ input file?  '
read S1_FASTQ_INPUT_FILE

if test ! -f $S1_FASTQ_INPUT_FILE ; then
  printf "\nNo matching file name!!!  Aborting!!!\n\n"
  exit 192
fi

printf '\nWhat is the name of the S2 FASTQ input file?  '
read S2_FASTQ_INPUT_FILE

if test ! -f $S2_FASTQ_INPUT_FILE ; then
  printf "\nNo matching file name!!!  Aborting!!!\n\n"
  exit 192
fi

printf '\nHow many CPUs/threads do you want to use (may I suggest 7 or 8)?  '
read NUM_CPU

if test $NUM_CPU -ge 20 ; then
  printf "\nUsing 20 or more CPUs is overkill!!!  Aborting!!!\n\n"
  exit 192
fi

printf "\nWhat will be the basename for the reference and mapped reads files?  "
read REF_MAP_BASENAME

printf '\nWhat is the name for the directory where final mapping files should be placed?  '
read FINAL_INDEX_DIR

if test ! -d $FINAL_INDEX_DIR ; then
  mkdir -p ${FINAL_INDEX_DIR}_bowtie2
fi

### LET THE MAPPING BEGIN WITH BOWTIE2!!! ###

${BT_BUILD} ${SCAFFOLD_INPUT_FILE} ${REF_MAP_BASENAME}
${BT2} -p ${NUM_CPU} -x ${REF_MAP_BASENAME} -1 ${S1_FASTQ_INPUT_FILE} -2 ${S2_FASTQ_INPUT_FILE} --qc-filter -S ${REF_MAP_BASENAME}.bowtie2.mapped.reads
mv ${REF_MAP_BASENAME}.bowtie2.mapped.reads ${REF_MAP_BASENAME}.bowtie2.mapped.reads.sam
${SAMTOOLS} view -bS -T ${SCAFFOLD_INPUT_FILE} ${PWD}/${REF_MAP_BASENAME}.bowtie2.mapped.reads.sam > ${PWD}/${REF_MAP_BASENAME}.bowtie2.mapped.reads.bam
${SAMTOOLS} sort ${PWD}/${REF_MAP_BASENAME}.bowtie2.mapped.reads.bam ${PWD}/${REF_MAP_BASENAME}.bowtie2.mapped.sorted
${SAMTOOLS} index ${PWD}/${REF_MAP_BASENAME}.bowtie2.mapped.sorted.bam

### SOME BASIC HOUSEKEEPING AND RM OF BOWTIE2 FILES THAT ARE NO LONGER NEEDED ###

mkdir ${FINAL_INDEX_DIR}_bowtie2/for_visualization
cp ${SCAFFOLD_INPUT_FILE} ${FINAL_INDEX_DIR}_bowtie2/for_visualization
mv ${PWD}/${REF_MAP_BASENAME}.bowtie2.mapped.sorted.bam ${FINAL_INDEX_DIR}_bowtie2/for_visualization
mv ${PWD}/${REF_MAP_BASENAME}.bowtie2.mapped.sorted.bam.bai ${FINAL_INDEX_DIR}_bowtie2/for_visualization
mv ${FINAL_INDEX_DIR}_bowtie2/for_visualization ${FINAL_INDEX_DIR}_bowtie2/for_visualization_${TDSTAMP}
rm -f ${PWD}/*.bt2 ${PWD}/*.a* ${PWD}/*.bwt ${PWD}/*.fai ${PWD}/*.pac ${PWD}/*.sa ${PWD}/*.aln ${PWD}/*.[sb]am

fi

printf "\n\n"
printf "**************************************************************************\n"
printf "*				DONE!!!!				 *\n"
printf "*        Files needed for visualization in Tablet or IVG are in		 *\n"
printf '*      /path/to/final/mapping/files/for_visualization directories	 *\n'
printf "*      Remember to clean up after yourself by rm-ing unused files!!!     *\n"
printf "**************************************************************************\n"

exit 0
