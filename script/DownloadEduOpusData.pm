#!/usr/bin/perl

use strict;
package EduTool;

use JSON;
use Try::Tiny;
use LWP::UserAgent;
use POSIX qw(strftime);
use Search::Elasticsearch;

sub dowork
{
	my $param = shift;
	my $jsonparser = new JSON;
	my $es = Search::Elasticsearch->new(nodes=>['192.168.1.20:9200'], cxn_pool => 'Sniff');

	open(IN,$param)||die("The file can't find!\n");
	while(my $row = <IN>)
	{
		chomp($row);
		try
		{
			if($row =~ /{.*}/)
			{
				my $json = $jsonparser->decode($row);
				my $url = $json->{url};
				my $text = $json->{sample};
				my $score = $json->{score};
				my $length = $json->{length};
	
				if($score >= 95)
				{
					my $filename = create($url);
					my $code = getstore($url,$filename);
					if($code == 200)
					{
						insertElastic($es,$filename,$url,$text,$length,$score);
					}
					#die;
				}
			}
		}
		catch
		{
			print "Process ".$row." error!\n";
		};
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

sub getstore
{
	my($url, $file) = @_;
	my $ua = LWP::UserAgent->new;
	$ua->default_header('format' => 'opus');
	$ua->agent('Mozilla/5.0 '.$ua->_agent);

	my $request = HTTP::Request->new(GET => $url);
	my $response = $ua->request($request, $file);
 
	$response->code;
}

sub insertElastic
{
	my $es = shift;
	my $filename = shift;
	my $url = shift;
	my $sample = shift;
	my $length = shift;
	my $score = shift;
	
	$es->index(
		index => 'callserv_edu_oral_en',
		type  => 'data',
		id    => $filename,
		body  => {
			wavname => $filename,
			text    => $sample,
			server  => $url,
			length  => $length,	
		     	score	=> $score
		}
	);
}

1;
