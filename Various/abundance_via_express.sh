#!/bin/bash

### PRINT USAGE DIRECTIONS IF NO/INCORRECT ARGUMENTS ARE PROVIDED ####
if [ ! $# == 3 ]; then
  echo "Usage: $0 number_processors READS.fq transcriptome.fasta"
  exit
fi

#### SET UP THE VARIABLES AND PATHS TO BINARIES (WHICH SHOULD ALL BE INSTALLED AND AVAILABLE VIA $PATH) ####
NPROC=$1
READS=$2
FASTA=$3
BOWTIE=`which bowtie`
BOWTIEBUILD=`which bowtie-build`
SAMTOOLS=`which samtools`
EXPRESS=`which express`
MTHYR=`date | awk '{print ($2$6)}'`

#### GRABBING THE SPECIES NAME OUT OF THE FASTA FILE WILL NEEED TO BE TWEAKED DEPENDING ON SITUATION ####
SPECIES=`head -1 $FASTA | sed -e 's/>//;s/_TRI_.*$//'`

#### REMOVE ANY OLD INDEX FILES THAT MIGHT BE IN THE CURRENT DIRECTORY FROM PREVIOUS RUNS ####
rm -rf index.*

#### RUN BWA, SAMTOOLS AND EXPRESS TO QUANTIFY ABUNDANCES AND WRITE LOG FILES ####
${BOWTIEBUILD} --offrate 1 $FASTA index
${BOWTIE} -p $NPROC -aS --chunkmbs 512 --offrate 1 index $READS 2>${SPECIES}_${MTHYR}_bowtie.log | ${SAMTOOLS} view -Sb - > ${SPECIES}_${MTHYR}.bam
${SAMTOOLS} flagstat ${SPECIES}_${MTHYR}.bam > ${SPECIES}_${MTHYR}.map.stats &
${EXPRESS} -o ${SPECIES}_${MTHYR}.xprs -p $NPROC $FASTA ${SPECIES}_${MTHYR}.bam 2>${SPECIES}_${MTHYR}_express.log

#### RENAME FILES IN THE OUTPUT DIRECTORY WITH THE APPROPRIATE LABELS ####
mv ${SPECIES}_${MTHYR}.xprs/params.xprs ${SPECIES}_${MTHYR}.xprs/${SPECIES}_${MTHYR}_express_params.xprs
mv ${SPECIES}_${MTHYR}.xprs/results.xprs ${SPECIES}_${MTHYR}.xprs/${SPECIES}_${MTHYR}_express_results.xprs

#### CLEAN UP FILES THAT NOT BE NEEDED OR WANTED (TAILOR TO TASTE) ####
###rm -rf index.*
###rm -rf *.bam
