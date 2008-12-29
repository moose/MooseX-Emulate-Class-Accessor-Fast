package MooseX::Emulate::Class::Accessor::Fast::Meta::Accessor;

use strict;
use warnings;

use Carp 'confess';

use base 'Moose::Meta::Method::Accessor';

sub generate_accessor_method {
    my $attr = (shift)->associated_attribute;
    return sub {
        my $self = shift;
        $attr->set_value($self, $_[0]) if scalar(@_) == 1;
        $attr->set_value($self, [@_]) if scalar(@_) > 1;
        $attr->get_value($self);
    };
}

sub generate_writer_method {
    my $attr = (shift)->associated_attribute;
    return sub {
        my $self = shift;
        $attr->set_value($self, $_[0]) if scalar(@_) == 1;
        $attr->set_value($self, [@_]) if scalar(@_) > 1;
    };
}

# FIXME - this is shite, but it does work...
sub generate_accessor_method_inline {
    my $attr          = (shift)->associated_attribute;
    my $attr_name     = $attr->name;
    my $meta_instance = $attr->associated_class->instance_metaclass;#

    my $code = eval "sub {
        my \$self = shift;
        \$self->{'$attr_name'} = \$_[0] if scalar(\@_) == 1;
        \$self->{'$attr_name'} = [\@_] if scalar(\@_) > 1;
        \$self->{'$attr_name'};
    }";
    confess "Could not generate inline accessor because : $@" if $@;

    return $code;
}
*generate_writer_method_inline = \&generate_accessor_method_inline;

1;
