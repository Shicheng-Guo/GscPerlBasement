#!/usr/bin/perl
# merge bedGraph file by different chrosome(1-22, M, X, Y)
# Run the script to the Bam directory
# Contact: Shicheng Guo
# Version 1.3
# Update: 2016-08-11

# BedGraph File: /oasis/tscc/scratch/shg047/monod/Figure3
# OUT Dir: /home/shg047/oasis/Estellar2016/bam

use strict;
use Cwd;
my $submit="FALSE";
my $outdir="./";

die USAGE() if scalar(@ARGV)<2;
my $bamdir=shift @ARGV;
chdir $bamdir || die "$bamdir not avaibale\n";
my @file=glob("*.bedGraph");
$outdir=shift @ARGV;
$submit=shift @ARGV;
my %sam;
foreach my $file(@file){
        my ($sam,undef)=split /\./,$file;
        $sam{$sam}=$sam;
}
foreach my $sam(sort keys %sam){
        open OUT, ">$outdir/$sam.bam.merge.sh" || die "$sam.bam.merge.sh cannot open\n";
        print OUT "cd $bamdir\n";
        my @file=glob("$sam*bedGraph");
        my $file=join(" ",@file);
        print "$sam.bedGraph.merge.sh\n";
        print OUT "cat $file > $outdir/$sam.tmp\n";
        print OUT "grep -v track $outdir/$sam.tmp\n";
        close OUT;
        if($submit eq 'submit'){
        system("sh $outdir/$sam.bam.merge.sh &");
        }
}

sub USAGE{
        print "\nUSAGE: perl $0 BedGraphDirectory OutputDir submit\n\n";
        print "Example: perl $0 /media/LTS_60T/Dinh/BAM /media/LTS_60T/Shicheng/BAM submit\n";
        print "Note: The Directory Must Be Absolute Directory, not Relative Directory\n";
}
