#!/bin/bash

### This script is ugly and should be rewritten

REPORT=$2

if [ "$1" = BX-UNIPROT-ALL ]; then
  tail -n +2 $REPORT | awk -F"\t" '{print $3}' | awk -F"|" '{print $2}' | sed -e '/^$/d' | sort
  exit
elif [ "$1" = BX-UNIPROT-ALL-SC ]; then
  tail -n +2 $REPORT | awk -F"\t" '{print $3}' | awk -F"|" '{print $2}' | sed -e '/^$/d' | wc -l
  exit
elif [ "$1" = BX-UNIPROT-ALL-LC ]; then
  tail -n +2 $REPORT | awk -F"\t" '{print $3}' | awk -F"|" '{print $2}' | sed -e '/^$/d' | uniq -c | sort -n
  exit

elif [ "$1" = BX-UNIPROT-UNIQ ]; then
  tail -n +2 $REPORT | awk -F"\t" '{print $3}' | awk -F"|" '{print $2}' | sed -e '/^$/d' | sort | uniq 
  exit
elif [ "$1" = BX-UNIPROT-UNIQ-SC ]; then
  tail -n +2 $REPORT | awk -F"\t" '{print $3}' | awk -F"|" '{print $2}' | sed -e '/^$/d' | sort | uniq | wc -l
  exit
elif [ "$1" = BX-UNIPROT-UNIQ-LC ]; then
  tail -n +2 $REPORT | awk -F"\t" '{print $3}' | awk -F"|" '{print $2}' | sed -e '/^$/d' | sort | uniq | uniq -c 
  exit

elif [ "$1" = BP-UNIPROT-ALL ]; then
  tail -n +2 $REPORT | awk -F"\t" '{print $7}' | awk -F"|" '{print $2}' | sed -e '/^$/d' | sort
  exit
elif [ "$1" = BP-UNIPROT-ALL-SC ]; then
  tail -n +2 $REPORT | awk -F"\t" '{print $7}' | awk -F"|" '{print $2}' | sed -e '/^$/d' | wc -l
  exit
elif [ "$1" = BP-UNIPROT-ALL-LC ]; then
  tail -n +2 $REPORT | awk -F"\t" '{print $7}' | awk -F"|" '{print $2}' | sed -e '/^$/d' | uniq -c | sort -n
  exit

elif [ "$1" = BP-UNIPROT-UNIQ ]; then
  tail -n +2 $REPORT | awk -F"\t" '{print $7}' | awk -F"|" '{print $2}' | sed -e '/^$/d' | sort | uniq
  exit
elif [ "$1" = BP-UNIPROT-UNIQ-SC ]; then
  tail -n +2 $REPORT | awk -F"\t" '{print $7}' | awk -F"|" '{print $2}' | sed -e '/^$/d' | sort | uniq | wc -l
  exit
elif [ "$1" = BP-UNIPROT-UNIQ-LC ]; then
  tail -n +2 $REPORT | awk -F"\t" '{print $7}' | awk -F"|" '{print $2}' | sed -e '/^$/d' | sort | uniq | uniq -c
  exit

elif [ "$1" = BX-GENELIST-ALL ]; then
  tail -n +2 $REPORT | awk -F"\t" '{print $3}' | sed 's/.//' | sed -e '/^$/d' | awk -F"Full=" '{print $2}' | awk -F";" '{print $1}' | sort
  exit
elif [ "$1" = BX-GENELIST-ALL-SC ]; then
  tail -n +2 $REPORT | awk -F"\t" '{print $3}' | sed 's/.//' | sed -e '/^$/d' | awk -F"Full=" '{print $2}' | awk -F";" '{print $1}' | wc -l
  exit
elif [ "$1" = BX-GENELIST-ALL-LC ]; then
  tail -n +2 $REPORT | awk -F"\t" '{print $3}' | sed 's/.//' | sed -e '/^$/d' | awk -F"Full=" '{print $2}' | awk -F";" '{print $1}' | uniq -c | sort -n
  exit

elif [ "$1" = BX-GENELIST-UNIQ ]; then
  tail -n +2 $REPORT | awk -F"\t" '{print $3}' | sed 's/.//' | sed -e '/^$/d' | awk -F"Full=" '{print $2}' | awk -F";" '{print $1}' | sort | uniq
  exit
elif [ "$1" = BX-GENELIST-UNIQ-SC ]; then
  tail -n +2 $REPORT | awk -F"\t" '{print $3}' | sed 's/.//' | sed -e '/^$/d' | awk -F"Full=" '{print $2}' | awk -F";" '{print $1}' | sort | uniq | wc -l
  exit
elif [ "$1" = BX-GENELIST-UNIQ-LC ]; then
  tail -n +2 $REPORT | awk -F"\t" '{print $3}' | sed 's/.//' | sed -e '/^$/d' | awk -F"Full=" '{print $2}' | awk -F";" '{print $1}' | sort | uniq | uniq -c 
  exit

elif [ "$1" = BP-GENELIST-ALL ]; then
  tail -n +2 $REPORT | awk -F"\t" '{print $7}' | sed 's/.//' | sed -e '/^$/d' | awk -F"Full=" '{print $2}' | awk -F";" '{print $1}' | sort
  exit
elif [ "$1" = BP-GENELIST-ALL-SC ]; then
  tail -n +2 $REPORT | awk -F"\t" '{print $7}' | sed 's/.//' | sed -e '/^$/d' | awk -F"Full=" '{print $2}' | awk -F";" '{print $1}' | wc -l
  exit
elif [ "$1" = BP-GENELIST-ALL-LC ]; then
  tail -n +2 $REPORT | awk -F"\t" '{print $7}' | sed 's/.//' | sed -e '/^$/d' | awk -F"Full=" '{print $2}' | awk -F";" '{print $1}' | uniq -c | sort -n
  exit

elif [ "$1" = BP-GENELIST-UNIQ ]; then
  tail -n +2 $REPORT | awk -F"\t" '{print $7}' | sed 's/.//' | sed -e '/^$/d' | awk -F"Full=" '{print $2}' | awk -F";" '{print $1}' | sort | uniq
  exit
elif [ "$1" = BP-GENELIST-UNIQ-SC ]; then
  tail -n +2 $REPORT | awk -F"\t" '{print $7}' | sed 's/.//' | sed -e '/^$/d' | awk -F"Full=" '{print $2}' | awk -F";" '{print $1}' | sort | uniq | wc -l
  exit
elif [ "$1" = BP-GENELIST-UNIQ-LC ]; then
  tail -n +2 $REPORT | awk -F"\t" '{print $7}' | sed 's/.//' | sed -e '/^$/d' | awk -F"Full=" '{print $2}' | awk -F";" '{print $1}' | sort | uniq | uniq -c
  exit

elif [ "$1" = BX-TAXALIST-ALL ]; then
  tail -n +2 $REPORT | awk -F"\t" '{print $3}' | sed 's/.//' | sed -e '/^$/d' | awk -F"^" '{print $7}' | awk -F"\`" '{print $1}' | sort
  exit
elif [ "$1" = BX-TAXALIST-ALL-SC ]; then
  tail -n +2 $REPORT | awk -F"\t" '{print $3}' | sed 's/.//' | sed -e '/^$/d' | awk -F"^" '{print $7}' | awk -F"\`" '{print $1}' | wc -l
  exit
elif [ "$1" = BX-TAXALIST-ALL-LC ]; then
  tail -n +2 $REPORT | awk -F"\t" '{print $3}' | sed 's/.//' | sed -e '/^$/d' | awk -F"^" '{print $7}' | awk -F"\`" '{print $1}' | uniq -c | sort -n
  exit

elif [ "$1" = BX-TAXALIST-UNIQ ]; then
  tail -n +2 $REPORT | awk -F"\t" '{print $3}' | sed 's/.//' | sed -e '/^$/d' | awk -F"^" '{print $7}' | awk -F"\`" '{print $1}' | sort | uniq
  exit
elif [ "$1" = BX-TAXALIST-UNIQ-SC ]; then
  tail -n +2 $REPORT | awk -F"\t" '{print $3}' | sed 's/.//' | sed -e '/^$/d' | awk -F"^" '{print $7}' | awk -F"\`" '{print $1}' | sort | uniq | wc -l
  exit
elif [ "$1" = BX-TAXALIST-UNIQ-LC ]; then
  tail -n +2 $REPORT | awk -F"\t" '{print $3}' | sed 's/.//' | sed -e '/^$/d' | awk -F"^" '{print $7}' | awk -F"\`" '{print $1}' | sort | uniq | uniq -c
  exit

elif [ "$1" = BP-TAXALIST-ALL ]; then
  tail -n +2 $REPORT | awk -F"\t" '{print $7}' | sed 's/.//' | sed -e '/^$/d' | awk -F"^" '{print $7}' | awk -F"\`" '{print $1}' | sort
  exit
elif [ "$1" = BP-TAXALIST-ALL-SC ]; then
  tail -n +2 $REPORT | awk -F"\t" '{print $7}' | sed 's/.//' | sed -e '/^$/d' | awk -F"^" '{print $7}' | awk -F"\`" '{print $1}' | wc -l
  exit
elif [ "$1" = BP-TAXALIST-ALL-LC ]; then
  tail -n +2 $REPORT | awk -F"\t" '{print $7}' | sed 's/.//' | sed -e '/^$/d' | awk -F"^" '{print $7}' | awk -F"\`" '{print $1}' | uniq -c | sort -n
  exit

elif [ "$1" = BP-TAXALIST-UNIQ ]; then
  tail -n +2 $REPORT | awk -F"\t" '{print $7}' | sed 's/.//' | sed -e '/^$/d' | awk -F"^" '{print $7}' | awk -F"\`" '{print $1}' | sort | uniq
  exit
elif [ "$1" = BP-TAXALIST-UNIQ-SC ]; then
  tail -n +2 $REPORT | awk -F"\t" '{print $7}' | sed 's/.//' | sed -e '/^$/d' | awk -F"^" '{print $7}' | awk -F"\`" '{print $1}' | sort | uniq | wc -l
  exit
elif [ "$1" = BP-TAXALIST-UNIQ-LC ]; then
  tail -n +2 $REPORT | awk -F"\t" '{print $7}' | sed 's/.//' | sed -e '/^$/d' | awk -F"^" '{print $7}' | awk -F"\`" '{print $1}' | sort | uniq | uniq -c
  exit

elif [ "$1" = GO-ANNOTATION ]; then
  tail -n +2 $REPORT | awk -F"\t" '{print $12}' | sed -e '/^\./d;s/^G/\nG/;s/GO/\nGO/g;s/\`//g;s/\^/,/g;s/_/ /g;s/\n\n/\n/' | awk -F"\`" '{print $1}'
  exit

else
  printf "Usage: $0 INFO_2_PARSE Trinotate_report.tab\n"
  printf "Where INFO_2_PARSE is of the form:\n"
  printf "GO-ANNOTATION (for detailed info from just that field).\n"
  printf "or:\n"
  printf "[BX/BP]-[UNIPROT/GENELIST/TAXALIST]-[ALL/UNIQ]-[LC/SC]\n"
  printf "BX and BP are BLASTx and BLASTp fields, respectively.\n"
  printf "LC and SC flags are for long and short counts, respectively. Either are optional.\n" 
  exit
fi
