#!/bin/bash

## Automated the annotation of Trinity transcriptome assemblies via the Trinotate pipeline
## This script is meant to be run in a directory containing at least one Trinity assembly
## Since the for loop will operate on any file ending in .fasta, best to run it in a directory with just the Trinity assemblies you are interested in annotating
## $PATH for executables and DBs used by this script are hardcoded to The Molette Lab server SkyNet, so modify those accordingly to your situation
## printf statements in the for loop append start times of each step to a log in the parent directory where the script was executed
## Written November 17th, 2013 by S.R. Santos, Department of Biological Sciences, Auburn University

## Keep bash shell from globbing unless explicitly told to
shopt -s nullglob

### Create variables for Trinity installation and other binaries
### Helps to account for different system configurations
TRINITY_HOME=/usr/local/genome/trinityrnaseq_r2013-11-10
BLASTX=`which blastx`
BLASTP=`which blastp`
HMMSCAN=`which hmmscan`
SIGNALP=`which signalp`
TMHMM=`which tmhmm`

### Start looping through the Trinity assemblies *.fasta files
for FILENAME in *.fasta
do
	### Create a variable for the date and then species whose transcriptome is being annotated and set up a specific directory for the annotation to be done in (keeps things tidy)
	### This will need to be modified depending on the specifics of your FASTA descriptor
	MTHYR=`date | awk '{print ($2$6)}'`
	SPECIES=`head -1 $FILENAME | sed -e 's/>//;s/_TRI_.*$//'`
	mkdir ${SPECIES}_Trinotate_${MTHYR}
	mv $FILENAME ${SPECIES}_Trinotate_${MTHYR}
	cd ${SPECIES}_Trinotate_${MTHYR}
	PARENT_DIR=`pwd | awk -F"/" {'print $(NF-1)'}`
	### Extract the most likely longest-ORF peptide candidates from the Trinity assembly using TransDecoder and remove the empty tmp directory when done
	printf "Started transdecoder for ${SPECIES} on `date` ......\n" >> ../Trinotate_run_${PARENT_DIR}_${MTHYR}.log
	$TRINITY_HOME/trinity-plugins/TransDecoder_r20131110/TransDecoder -t $FILENAME
	rm -rf *.tmp*
	### BLAST the raw transcripts (blastx) and peptide candidates (blastp) against the UNIProt database; save single best hit in tab delimited format
        printf "Started blastp for ${SPECIES} on `date` ......\n" >> ../Trinotate_run_${PARENT_DIR}_${MTHYR}.log
        ${BLASTP} -query ${FILENAME}.transdecoder.pep -db /home/db_4_Trinotate/uniprot_sprot_2013-07-04 -num_threads 10 -max_target_seqs 1 -outfmt 6 > ${SPECIES}_blastp.outfmt6
	printf "Started blastx for ${SPECIES} on `date` ......\n" >> ../Trinotate_run_${PARENT_DIR}_${MTHYR}.log
	${BLASTX} -query $FILENAME -db /home/db_4_Trinotate/uniprot_sprot_2013-07-04 -num_threads 10 -max_target_seqs 1 -outfmt 6 > ${SPECIES}_blastx.outfmt6
	### Run HMMER to identify protein domains in the most likely longest-ORF peptide candidates from the Trinity assembly
	printf "Started hmmscan for ${SPECIES} on `date` ......\n" >> ../Trinotate_run_${PARENT_DIR}_${MTHYR}.log
	${HMMSCAN} --cpu 10 --domtblout ${SPECIES}_TrinotatePFAM.out /home/db_4_Trinotate/Pfam-A.hmm ${FILENAME}.transdecoder.pep > ${SPECIES}_pfam.log
	### Run signalP to predict signal peptides in the most likely longest-ORF peptide candidates from the Trinity assembly
	printf "Started signalp for ${SPECIES} on `date` ......\n" >> ../Trinotate_run_${PARENT_DIR}_${MTHYR}.log
	${SIGNALP} -f short -n ${SPECIES}_signalp.out ${FILENAME}.transdecoder.pep
	### Run tmHMM to predict transmembrane regions in the most likely longest-ORF peptide candidates from the Trinity assembly
	printf "Started tmhmm for ${SPECIES} on `date` ......\n" >> ../Trinotate_run_${PARENT_DIR}_${MTHYR}.log
	${TMHMM} --short < ${FILENAME}.transdecoder.pep > ${SPECIES}_tmhmm.out
	### Remove the empty tmp directory left by tmhmm and move up into the parent directory
	rm -rf TMHMM_*
	printf "DONE - Trinotate annotation of ${SPECIES} completed at `date` \n" >> ../Trinotate_run_${PARENT_DIR}_${MTHYR}.log
	cd ..
	### Now tar.gz to save space and delete original directory/files
	tar -pczf ${SPECIES}_Trinotate_${MTHYR}.tar.gz ${SPECIES}_Trinotate_${MTHYR}/
	rm -rf ${SPECIES}_Trinotate_${MTHYR}/
	### Now continue back to beginning of da_loop for any remaining Trinity assemblies
done
