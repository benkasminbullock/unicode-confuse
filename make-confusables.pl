#!/home/ben/software/install/bin/perl
use warnings;
use strict;
use utf8;
use FindBin '$Bin';
use JSON::Create 'write_json';
use lib "$Bin/lib";
use Unicode::Confuse;
use Getopt::Long;

my $file = '/home/ben/data/unicode/confusables/confusablesSummary.txt';
my $ok = GetOptions (
    "file=s" => \$file,
    verbose => \my $verbose,
);
if (! $ok || ! -f $file) {
    print <<EOF;
This script is part of the Unicode::Confuse Perl distribution.

It regenerates the JSON file distributed with this module. Run it as
follows:

    $0 --file </path/to/confusablesSummary.txt>

Download the confusables file from

    https://www.unicode.org/Public/security/latest/confusablesSummary.txt

EOF
    exit;
}
if ($verbose) {
    print "Parsing the file ...\n";
}
my $con = Unicode::Confuse::parse_file ($file);
my $dir = "$Bin/lib/Unicode/Confuse";
if (! -d $dir) {
    system ("mkdir -p $dir");
}
my $out = "$dir/confusables.json";
write_json ($out, $con, indent => 1, sort => 1);
exit;
