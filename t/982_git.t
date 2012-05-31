#!/usr/bin/perl

use Test::More;

use strict;
use warnings;
no  warnings 'syntax';

unless ($ENV {AUTHOR_TESTING}) {
    plan skip_all => "AUTHOR tests skipped";
    exit;
}

unless (-f ".git/config") {
    plan skip_all => "This is not a git repository";
    exit;
}

undef $ENV {PATH};
my $GIT  = "/opt/git/bin/git";
my $HEAD = "/usr/bin/head";

my @output = `$GIT status --porcelain`;

ok @output == 0, "All files are checked in";

my @tags = sort grep {/^release/} `$GIT tag`;

chomp (my $final_tag = $tags [-1]);

my $changes_line = `$HEAD -1 Changes`;

ok $final_tag    && 
   $changes_line &&
   $final_tag eq "release-" . ($changes_line =~ /^Version ([0-9]{10})/) [0],
   "git tag matches version";


done_testing;
