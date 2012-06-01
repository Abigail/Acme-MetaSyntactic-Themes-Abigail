#!/usr/bin/perl

use Test::More;

use strict;
use warnings;
no  warnings 'syntax';

unless ($ENV {AUTHOR_TESTING}) {
    plan skip_all => "AUTHOR tests";
    exit;
}

undef $ENV {PATH};
my $FIND  = "/usr/bin/find";

my $top   = -d "blib" ? "blib/lib" : "lib";
my @files = `$FIND $top -name [a-z_]*.pm`;
chomp @files;

my $main  = "$top/Acme/MetaSyntactic/Themes/Abigail.pm";

open my $fh, "<", $main or do {
    fail "Open $main: $!";
    done_testing;
    exit;
};

undef $/;
my $text = <$fh>;

foreach my $file (@files) {
    $file =~ s!.*/!!;
    $file =~ s/\.pm//;
    ok $text =~ /C<< \Q$file\E >>/, "Theme '$file' mentioned in main POD";
}


done_testing;
