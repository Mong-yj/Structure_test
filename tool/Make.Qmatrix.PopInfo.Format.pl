#!/usr/bin/perl 
#===============================================================================
#
#         FILE: Make.Qmatrix.PopInfo.Format.pl
#
#        USAGE: ./Make.Qmatrix.PopInfo.Format.pl  
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
#      CREATED: 05/08/2020 03:04:20 PM
#     REVISION: ---
#===============================================================================


open (IN, "$ARGV[0]\_structureOUT/$ARGV[1]") or die "Can't open file\n";
$ARGV[1] =~ /K(\d)_\d_f/;
$K = $1;
$K_index = $K - 1;

$Count=0;
$Sample=0;
while(<IN>)
{
	if($_ =~ /Label/ && $Count == 0)
	{
		$Count++;
	}
	elsif($_ !~ /Label/ && $Count == 1)
	{
		$Sample++;
		if($Sample <= $ARGV[2])
		{
			chomp($_);
			$_ =~ s/^\s+//;
			($Num, $ID, $Miss, $Pop, $Symbol, @Data) = split(/\s+/, $_);
			$Pop_index = $Pop - 1;
			$Prior = join(" ", @Data);

			if ($Prior =~ /Pop/)
			{
				@Info = split(/ \| Pop \d/, $Prior);
				@Array = ();
				$Info[0] =~ s/^\s+//;
				$Value = 0;

				if($Pop == 1)
				{
					push(@Array, $Info[0]);
					foreach $i (1 .. $K_index)
					{
						($Trash, @P) = split(/ /, $Info[$i]);
						foreach $j (@P)
						{
							$j =~ s/^\s+//;
							if($j !~ /\|/ && $j !~ /\*/)
							{
								$Value = $Value + $j;
							}
						}
						push(@Array, $Value);
						$Value = 0;
					}
					print join " ", "@Array\n";
				}
				elsif($Pop == $K)
				{
					foreach $i (1 .. $K_index)
					{
						($Trash, @P) = split(/ /, $Info[$i]);
						foreach $j (@P)
						{
							$j =~ s/^\s+//;
							if($j !~ /\|/ && $j !~ /\*/)
							{
								$Value = $Value + $j;
							}
						}
						push(@Array, $Value);
						$Value = 0;
					}
					push(@Array, $Info[0]);
					print join " ", "@Array\n";
				}
				else
				{
					foreach $i (1 .. $K_index)
					{
						($Trash, @P) = split(/ /, $Info[$i]);
						foreach $j (@P)
						{
							$j =~ s/^\s+//;
							if($j !~ /\|/ && $j !~ /\*/)
							{
								$Value = $Value + $j;
							}

						}

						if ($i == $Pop)
						{
							push(@Array, $Info[0]);
							push(@Array, $Value);
						}
						else
						{
							push(@Array, $Value);
						}
						$Value = 0;
					}
					print join " ", "@Array\n";
				}
			}
			else
			{
				print "$Prior\n";
			}
		}
		else
		{
			exit;
		}
	}
}

close (IN);
