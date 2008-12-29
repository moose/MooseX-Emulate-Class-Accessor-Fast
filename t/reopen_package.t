use Test::More tests => 9;
use Test::Exception;

# 1
BEGIN { require_ok("MooseX::Adopt::Class::Accessor::Fast"); }

use Class::MOP;
use Class::Accessor::Fast;
@My::Class::ISA = 'Class::Accessor::Fast';
my $meta = Class::MOP::get_metaclass_by_name('My::Class') 
  || Class::MOP::Class->initialize('My::Class');
$meta->make_immutable;

my @warnings;
$SIG{__WARN__} = sub { push(@warnings, shift) };

# 2-4
lives_ok { My::Class->mk_accessors('foo') } 'mk_accessors on immutable';
lives_ok { My::Class->mk_ro_accessors('quux') } 'mk_ro_accessors on immutable';
lives_ok { My::Class->mk_wo_accessors('flibble') } 'mk_wo_accessors on immutable';

# 5-7
lives_ok { My::Class->make_accessor('bar') } 'mk_accessor on immutable';
lives_ok { My::Class->make_ro_accessor('gong') } 'mk_ro_accessor on immutable';
lives_ok { My::Class->make_wo_accessor('wibble') } 'mk_wo_accessor on immutable';

# 8
lives_ok { My::Class->follow_best_practice } 'follow_best_practice on immutable';

# 9
is( scalar(@warnings), 7, '7 warnings' );

