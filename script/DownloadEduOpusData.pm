#!/usr/bin/perl

use strict;
package EduTool;

use warnings;
use LWP::UserAgent;
use JSON;
use POSIX qw(strftime);

sub dowork
{
	my $param = shift;
	my $jsonparser = new JSON;

	my $json = $jsonparser->decode($param);
	my $url = $json->{url};
	my $text = $json->{sample};

	my $filename = create($url);
	open(OUT,">$filename")||die("The file can't create!\n");

	my $ua = LWP::UserAgent->new;
	$ua->default_header('format' => "opus");
	 
	my $response = $ua->get($url);
	if($response->is_success)
	{
	    print OUT $response->decoded_content;
	    print $filename."|".$text."\n";
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

	my $filename = $arr[6];
	my $unixtime = substr($arr[7],0,10);

	my $str = "date -d \@$unixtime +\"%Y-%m-%d_%H\"";
	my $res = qx($str);	
	$res =~ s/[\r\n]//g;
	
	`mkdir -p '/backup/edu-data/'$res`;

	return '/backup/edu-data/'.$res.'/'.$filename.'.opus';
}

1;
