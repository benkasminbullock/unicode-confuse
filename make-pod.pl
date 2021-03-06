#!/home/ben/software/install/bin/perl
use warnings;
use strict;
use Template;
use FindBin '$Bin';
use Perl::Build qw/get_info get_commit/;
use Perl::Build::Pod ':all';
use Deploy qw/do_system older/;
use Getopt::Long;
use JSON::Parse 'read_json';
use ExtUtils::ParseXS::Utilities 'trim_whitespace';
use File::Slurper 'write_text';

my $ok = GetOptions (
    'force' => \my $force,
    'verbose' => \my $verbose,
);
if (! $ok) {
    usage ();
    exit;
}
my %pbv = (
    base => $Bin,
    verbose => $verbose,
);
my $info = get_info (%pbv);
my $commit = get_commit (%pbv);
# Names of the input and output files containing the documentation.

my $pod = 'Confuse.pod';
my $input = "$Bin/lib/Unicode/$pod.tmpl";
my $output = "$Bin/lib/Unicode/$pod";

# Template toolkit variable holder

my $metadata = read_json ("$Bin/confusables-metadata.json");

my %vars = (
    info => $info,
    commit => $commit,
    metadata => $metadata,
);

my $tt = Template->new (
    ABSOLUTE => 1,
    INCLUDE_PATH => [
	$Bin,
	pbtmpl (),
	"$Bin/examples",
    ],
    ENCODING => 'UTF8',
    FILTERS => {
        xtidy => [
            \& xtidy,
            0,
        ],
    },
    STRICT => 1,
);

my @examples = <$Bin/examples/*.pl>;
for my $example (@examples) {
    my $output = $example;
    $output =~ s/\.pl$/-out.txt/;
    if (older ($output, $example) || $force) {
	do_system ("perl -I$Bin/lib $example > $output 2>&1", $verbose);
    }
}

chmod 0644, $output;
$tt->process ($input, \%vars, \my $outtext, binmode => 'utf8')
    or die '' . $tt->error ();
trim_whitespace ($outtext);
$outtext .= "\n";
$outtext =~ s!\n\n+!\n\n!g;
write_text ($output, $outtext);
chmod 0444, $output;

exit;

sub usage
{
    print <<USAGEEOF;
--verbose
--force
USAGEEOF
}

