#!/usr/bin/perl

use strict;
use threads;
use script::ParserEduCSVData;

if(scalar(@ARGV) != 2)
{
	print "Usage : $0 input threadnum\n";
	exit;
}

&Main();

sub Main
{
	my $threadnum = $ARGV[1];

	open(IN,$ARGV[0])||die("The file can't find!\n");
	my @tasks = <IN>;
	my $group = div(\@tasks,$threadnum);

	my @threads;
	foreach my $key (keys %$group)
	{
		my $thread = threads->create(\&dowork,$group->{$key});
		push @threads,$thread;
	}

	foreach(@threads)
	{
		$_->join();
	}
}

sub div
{
	my $ref = shift;
	my $threadnum = shift;

	my $res;
    	for(my $i = 0; $i < scalar(@$ref); $i++)
   	{
   		my $flag = $i%$threadnum;
   		push @{$res->{$flag}},$ref->[$i];
    	}

    	return $res;
}

sub dowork
{
	my $param = shift;
	
	foreach my $row (@$param)
	{
		chomp($row);
		print "Processing ".$row." now!\n";
		EduTool::dowork($row);
	}
}

1;


