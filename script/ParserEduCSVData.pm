#!/usr/bin/perl

use strict;
package EduTool;
use JSON;

sub dowork
{
	my $file = shift;
	my ($filehandle,$csvfile) = uncompress($file);
	parser($filehandle,$csvfile) if $filehandle;
	print "The file ".$file." has been processed!\n";
}

sub parser
{
	my $filehandle = shift;
	my $csvfile = shift;

	my $jsonparser = new JSON;
	my $res;

	my $random = qx(uuidgen);
	$random =~ s/[\r\n]//g;
	my $resfile = "res/res-$random.txt";
	open(OUT,">$resfile")||die("The file can't create!\n");
	
	while(my $row = <$filehandle>)
	{
		chomp($row);
		$row = replace($row);
		my @res = split(/lywlywlyw1/,$row);
		
		foreach my $row_in (@res)
		{
			if($row_in =~ /score/)
			{
				my @arr = split(/\|/,$row_in);
				if(scalar(@arr) == 21 and $arr[14] =~ /{.*}/)
				{
					my $json = $jsonparser->decode($arr[14]);
				
					my $area;
					$area = 'sh' if $arr[6] =~ /sh/;
					$area = 'gz' if $arr[6] =~ /gz/;
					$area = 'bj' if $arr[6] =~ /bj/;
				
					my $score = $json->{lines}->[0]->{score};
					my $sample = $json->{lines}->[0]->{sample};
					my $length = $json->{lines}->[0]->{end};
					my $url = "http://edu".$area.".hivoice.cn:9088/WebAudio-1.0-SNAPSHOT/audio/play/".$arr[2]."/".$arr[3]."/".$area;
				
					$res->{sample} = $sample;
					$res->{length} = $length;
					$res->{url} = $url;
					$res->{score} = $score;

					print OUT $jsonparser->encode($res)."\n";
					#print $jsonparser->encode($res)."\n";
				}
			}
		}	
	}

	unlink($csvfile);
}

sub replace
{
	my $text = shift;

	my $res = $text;
	$res =~ s/\\l/l/g;
	$res =~ s/\\c/c/g;
	$res =~ s/\\\\"//g;
	$res =~ s/ctqctqctq/|/g;

	return $res;
}

sub uncompress
{
	my $file = shift;

	my $csvfile;
	if($file =~ /(.*\/.*).gz$/)
	{
		$csvfile = $1;
		`gzip -d -f $file` unless -e $csvfile;
		open(IN,$csvfile)||die("The file can't find!\n");
		return \*IN,$csvfile;
	}
	else
	{
		return;
	}
}

1;

