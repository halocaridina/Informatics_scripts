#! /bin/bash

# Create variable for timedate stamping

MTHYR=`date | awk '{print ($2$6)}'`

# Sanity check

if test -d ""$HOME"/Updated_SYMBLAST_"${MTHYR}"" ; then
	exit 192
fi

# Create directory for making the DBs

mkdir $HOME/Updated_SYMBLAST_"${MTHYR}" ; cd $HOME/Updated_SYMBLAST_"${MTHYR}"

# Execute command
/usr/local/genome/scripts/UpdateSYMBLAST.sh
