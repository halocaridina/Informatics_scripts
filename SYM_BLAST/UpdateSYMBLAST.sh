#! /bin/bash

# Be sure to execute this script from a directory that contains no other files!!!

# Perl scripts to download sequences from GenBank

perl /usr/local/genome/scripts/auto_NCBI_retrieval_DINONUC.pl
perl /usr/local/genome/scripts/auto_NCBI_retrieval_DINONUC_EST.pl
perl /usr/local/genome/scripts/auto_NCBI_retrieval_DINOPRO.pl
perl /usr/local/genome/scripts/auto_NCBI_retrieval_SYMNUC.pl
perl /usr/local/genome/scripts/auto_NCBI_retrieval_SYMNUC_EST.pl
perl /usr/local/genome/scripts/auto_NCBI_retrieval_SYMPRO.pl

# Remove garbage from long downloads with sed

sed -i 's/Error.*$//;s/Resource.*$//' DinoNuc.fasta
sed -i 's/Error.*$//;s/Resource.*$//' DinoNuc_EST.fasta
sed -i 's/Error.*$//;s/Resource.*$//' DinoAmino.fasta
sed -i 's/Error.*$//;s/Resource.*$//' SymbioNuc.fasta
sed -i 's/Error.*$//;s/Resource.*$//' SymbioNuc_EST.fasta
sed -i 's/Error.*$//;s/Resource.*$//' SymbioAmino.fasta

# Combine nucleotide and EST downloads

cat DinoNuc_EST.fasta >> DinoNuc.fasta
cat SymbioNuc_EST.fasta >> SymbioNuc.fasta

# Remove any empty FASTA entries since those will cause formatdb to bomb

awk '$2{print RS $0}' FS='\n' RS=\> ORS= DinoNuc.fasta > tmp && mv tmp DinoNuc.fasta
awk '$2{print RS $0}' FS='\n' RS=\> ORS= SymbioNuc.fasta > tmp && mv tmp SymbioNuc.fasta
awk '$2{print RS $0}' FS='\n' RS=\> ORS= DinoAmino.fasta > tmp && mv tmp DinoAmino.fasta
awk '$2{print RS $0}' FS='\n' RS=\> ORS= SymbioAmino.fasta > tmp && mv tmp SymbioAmino.fasta

# Remove any duplicate entries using seqmagick

/opt/python2.7.9/bin/seqmagick mogrify --deduplicate-taxa DinoNuc.fasta > /dev/null 2>&1
/opt/python2.7.9/bin/seqmagick mogrify --deduplicate-taxa SymbioNuc.fasta > /dev/null 2>&1
/opt/python2.7.9/bin/seqmagick mogrify --deduplicate-taxa DinoAmino.fasta > /dev/null 2>&1
/opt/python2.7.9/bin/seqmagick mogrify --deduplicate-taxa SymbioAmino.fasta > /dev/null 2>&1

# Create shell variable with date and awk that will datestamp the new databases

MTHYR=`date | awk '{print ($2$6)}'`

# Format downloaded sequences into databases for BLAST

/usr/local/genome/blast-2.2.26/bin/formatdb -t DinoNuc${MTHYR} -i DinoNuc.fasta -p F -o T -s T -n DinoNuc
/usr/local/genome/blast-2.2.26/bin/formatdb -t DinoAmino${MTHYR} -i DinoAmino.fasta -p T -o T -s T -n DinoAmino
/usr/local/genome/blast-2.2.26/bin/formatdb -t SymbioNuc${MTHYR} -i SymbioNuc.fasta -p F -o T -s T -n SymbioNuc
/usr/local/genome/blast-2.2.26/bin/formatdb -t SymbioAmino${MTHYR} -i SymbioAmino.fasta -p T -o T -s T -n SymbioAmino

# Tarball and datestamp the files for transfer to server

tar -czf ${MTHYR}SYMBLASTfiles  *.*

# Remove the original files that now comprise the tarball

rm -f *.*

# Add extention back to tarball

mv ${MTHYR}SYMBLASTfiles ${MTHYR}SYMBLASTfiles.tar.gz

# Email that job is completed and DBs ready to move

/usr/sbin/sendmail santosr@auburn.edu < /usr/local/share/doc/email.txt
