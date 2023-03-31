#!/usr/bin/perl 
#===============================================================================
#
#         FILE: Make.strct_in.PopInfo.Format.pl
#
#        USAGE: ./Make.strct_in.PopInfo.Format.pl  
#
#  DESCRIPTION: 
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
#      COMPANY: 
#      VERSION: 1.0
#      CREATED: 05/08/2020 01:43:22 PM
#     REVISION: ---
#===============================================================================


open (POPINFO, "PopInfo") or die "Can't open PopInfo file\n";
%PopInfo=();

while(<POPINFO>)
{
	chomp($_);
	($ID, $Pop, $Flag) = split(/\t/, $_);
	$PopInfo{$ID}{"POP"} = $Pop;
	$PopInfo{$ID}{"FLAG"} = $Flag;
}
close (POPINFO);


###################################################################


open (STRUCTURE, "$ARGV[0].recode.strct_in") or die "can't open $ARGV[0].recode.strct_in file\n";
$Count=0;

open (OUT, ">$ARGV[0]\_PopInfo.recode.strct_in") or die "can't open $ARGV[0].recode.strct_in file\n";

while(<STRUCTURE>)
{
	$Count++;
	chomp($_);
	if($Count <= 2)
	{
		print OUT "$_\n";
	}
	else
	{
		($ID, $Pre_Pop, @Data) = split(/ /, $_);
		print OUT "$ID $PopInfo{$ID}{POP} $PopInfo{$ID}{FLAG} @Data\n";

	}
}
close (STRUCTURE);
