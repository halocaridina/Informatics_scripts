#!/usr/bin/perl
#
#Written by Paul Stothard, Canadian Bioinformatics Help Desk
#based on a script by Oleg Khovayko http://olegh.spedia.net
#
#Modified by S.R. Santos, Sept. 2005
#
#This script uses NCBI's Entrez Programming Utilities to perform
#batch requests to NCBI Entrez.
#
#See 'Entrez Programming Utilities' for more info at
#http://eutils.ncbi.nlm.nih.gov/entrez/query/static/eutils_help.html


use warnings;
use strict;
use LWP::Simple;

my $db = 'nucest';

my $query = 'Symbiodinium';

my $report = 'fasta';

my $output_file = 'SymbioNuc_EST.fasta';

my $stat_file = 'monthly_download.txt';

my $url = "http://eutils.ncbi.nlm.nih.gov/entrez/eutils";
my $esearch = "$url/esearch.fcgi?" . "db=$db&retmax=1&usehistory=y&term=";

my $esearch_result = get($esearch . $query);

$esearch_result =~  m/<Count>(\d+)<\/Count>.*<QueryKey>(\d+)<\/QueryKey>.*<WebEnv>(\S+)<\/WebEnv>/s;

my $count = $1;
my $query_key = $2;
my $web_env = $3;

my $retstart;
my $retmax = 500;

open (OUTFILE, ">" . $output_file) or die ("Error: Cannot open $output_file : $!");

my $response = 'y';

if ($response eq 'y') {

for ($retstart = 0; $retstart < $count; $retstart = $retstart + $retmax) {
    my $efetch = "$url/efetch.fcgi?" . "rettype=$report&retmode=text&retstart=$retstart&retmax=$retmax&" . "db=$db&query_key=$query_key&WebEnv=$web_env";

    my $efetch_result = get($efetch);

    print (OUTFILE $efetch_result);
    sleep(3);
}
		}
close (OUTFILE) or die ("Error: Cannot close $output_file file: $!");


open (OUTFILE, ">>" . $stat_file) or die;

print (OUTFILE "Symbiodinium nucleotide EST download from NCBI = $count\n");

close (OUTFILE) or die ("Error: Cannot close $output_file file: $!");