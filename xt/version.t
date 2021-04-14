use warnings;
use strict;
use utf8;
use FindBin '$Bin';
use Test::More;
my $builder = Test::More->builder;
binmode $builder->output,         ":utf8";
binmode $builder->failure_output, ":utf8";
binmode $builder->todo_output,    ":utf8";
binmode STDOUT, ":encoding(utf8)";
binmode STDERR, ":encoding(utf8)";
ok (-d "$Bin/../blib/lib", "Have built version to test against");
ok (-d "$Bin/../blib/arch", "Have built version to test against");
BEGIN: {
    use lib "$Bin/../blib/lib";
    use lib "$Bin/../blib/arch";
};
use Unicode::Confuse::Parse;
use Unicode::Confuse;
use Unicode::Confuse::Regex;
is ($Unicode::Confuse::Parse::VERSION, $Unicode::Confuse::VERSION, "Parse/Confuse versions coincide");
is ($Unicode::Confuse::Parse::VERSION, $Unicode::Confuse::Regex::VERSION, "Parse/Regex versions coincide");
is ($Unicode::Confuse::VERSION, $Unicode::Confuse::Regex::VERSION, "Confuse/Regex versions coincide");

done_testing ();
