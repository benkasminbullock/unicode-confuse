package Unicode::Confuse;
use warnings;
use strict;
use Carp;
use utf8;
require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw/confusable canonical/;
our %EXPORT_TAGS = (
    all => \@EXPORT_OK,
);
our $VERSION = '0.01';

use JSON::Parse 'read_json';

# This is not exported. It parses the original confusables file.

sub parse_file
{
    my ($file) = @_;
    return {};
}


1;
