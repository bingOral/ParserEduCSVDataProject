#!/usr/bin/perl

use strict;
package EduTool;

use warnings;
use LWP::UserAgent;

sub dowork
{
	my $url = shift;

	my $filename = create($url);
	open(OUT,">$filename")||die("The file can't create!\n");

	my $ua = LWP::UserAgent->new;
	$ua->default_header('format' => "opus");
	 
	my $response = $ua->get($url);
	if($response->is_success)
	{
	    print OUT $response->decoded_content;
	}
	else
	{
	    print $url."\n";
	}
}

sub create
{
	my $url = shift;

	my @arr = split(/\//,$url);

	my $filename = $arr[8];
	my ($sec, $min, $hour, $day, $month, $year) = (localtime(substr($arr[7],0,10)))[0,1,2,3,4,5,6];
	my $dir = '/backup/edu-data/'.$year.'-'.$month.'-'.$day.'_'.$hour;
	
	mkdir($dir) unless (-e $dir);

	return $dir.'/'.$filename.'.opus';
}

1;
