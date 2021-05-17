#!/home/ben/software/install/bin/perl

# The CPAN perl-reversion script seems to be making a muddle of things
# sometimes, and it doesn't edit Changes, so I've made my own script.

use warnings;
use strict;
use utf8;
use FindBin '$Bin';
use File::Slurper qw!read_text write_text!;
use Deploy 'make_date';

my $newversion = '0.05';
my $version = '0.04';

my @pmfiles = qw!
    lib/Unicode/Confuse.pm
    lib/Unicode/Confuse/Parse.pm
!;

for my $file (@pmfiles) {
    my $bfile = "$Bin/$file";
    my $text = read_text ($bfile);
    if ($text =~ s/\Q$version\E\b/$newversion/g) {
	print "$file OK\n";
	write_text ($bfile, $text);
    }
    elsif ($text =~ /\Q$newversion/) {
	warn "$file already at $newversion";
    }
    else {
	warn "$file failed";
    }
}

my $date = make_date ('-');
my $changes = "$Bin/Changes";
my $text = read_text ($changes);
my $latest = <<EOF;
$newversion $date

-

EOF

if ($text =~ s/(\Q$version\E)/$latest$1/g) {
    write_text ($changes, $text);
}
else {
    warn "$changes failed";
}
