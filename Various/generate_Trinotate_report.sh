#!/bin/bash

## Takes the output of the auto-Trinotate.sh script (i.e., Trinity assembled transcriptome annotated via the Trinotate pipeline) and produces
## a tab-delimited report that can be opened in Excel or worked with from the CLI
## This script is meant to be run in a directory containing at least one *.tar.gz file from the auto-Trinotate.sh script
## $PATH for executables and DBs used by this script are hardcoded to The Molette Lab server SkyNet, so modify those accordingly to your situation
## Written November 22nd, 2013 by S.R. Santos, Department of Biological Sciences, Auburn University

## Keep bash shell from globbing unless explicitly told to
shopt -s nullglob

### Create some variables for use later
MTHYR=`date | awk '{print ($2$6)}'`
TRINITY_HOME=/usr/local/genome/trinityrnaseq_r2013-11-10
TRINOTATE_HOME=/usr/local/genome/Trinotate_r20131110

### Start looping through the *.tar.gz files from the auto-Trinotate.sh script
for FILENAME in *.tar.gz
do
	### Unpack the .tar.gz and cd into it
	tar xvfz $FILENAME
	WKDIR=`echo $FILENAME | sed 's/.tar.gz//'`
	cd $WKDIR
	### Grab a clean copy of the boilerplate Trinotate SQLite DB from local storage
	cp /home/db_4_Trinotate/Trinotate.sqlite.gz .
	gunzip Trinotate.sqlite.gz
	### Create a variable for the species
	SPECIES=`head -1 *.fasta | sed -e 's/>//;s/_TRI_.*$//'`
	### Create the gene-transcript map using one of the helper scripts from Trinity
	$TRINITY_HOME/util/get_Trinity_gene_to_trans_map.pl *.fasta > ${SPECIES}.fasta.gene_trans_map
	### Start populating the Trinotate DB with the data from the auto-Trinotate.sh script
	$TRINOTATE_HOME/Trinotate Trinotate.sqlite init --gene_trans_map ${SPECIES}.fasta.gene_trans_map --transcript_fasta *.fasta --transdecoder_pep *.pep
	$TRINOTATE_HOME/Trinotate Trinotate.sqlite LOAD_blastp ${SPECIES}_blastp.outfmt6
	$TRINOTATE_HOME/Trinotate Trinotate.sqlite LOAD_blastx ${SPECIES}_blastx.outfmt6
	$TRINOTATE_HOME/Trinotate Trinotate.sqlite LOAD_pfam ${SPECIES}_TrinotatePFAM.out
	$TRINOTATE_HOME/Trinotate Trinotate.sqlite LOAD_tmhmm ${SPECIES}_tmhmm.out
	### Since not all transcriptomes (particularly small sized ones) will produce a signalp.out file, test for presence of the file and only do this step if present
	SIGNALP_FILE="./${SPECIES}_signalp.out"
	if [ -f "$SIGNALP_FILE" ]
	then
		$TRINOTATE_HOME/Trinotate Trinotate.sqlite LOAD_signalp ${SPECIES}_signalp.out
	else
		cd .
	fi
	### Create the tab-delimited report file. Can add a -E option here if want to increase statistical cutoff related to BLASTX and BLASTP
	$TRINOTATE_HOME/Trinotate Trinotate.sqlite report > ${SPECIES}_Trinotate_Annotation_Report_${MTHYR}.tab
	### Move the tab-delimited report file to the parent directory, cd .. and clean out what is no longer needed
	mv ${SPECIES}_Trinotate_Annotation_Report_${MTHYR}.tab ..
	cd ..
	rm -rf $FILENAME $WKDIR
### Now continue back to beginning of da_loop for any remaining .tar.gz files from the auto-Trinotate.sh script
done
