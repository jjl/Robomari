package Robomari;

use Moose;

has date => (
    is => 'ro',
    isa => 'Robomari::Date',
    lazy_build => 1,
);

has mail => (
    is => 'ro',
    isa => 'Robomari::Mail',
    lazy_build => 1,
);

sub _build_date {
    Robomari::Date->new;
}

sub _build_mail {
    Robomari::Mail->new(shift->date);
}

sub dispatch {
    my ($self) = @_;
    if ($self->date->is_announce) {
        #Sent out a fortnight before the social
        $self->mail->announce;
    } elsif ($self->date->is_reminder) {
        #Sent out the monday of the social
        $self->mail->remind_1;
    } elsif ($self->date->is_social) {
        #Sent out the day of the social
        $self->mail->remind_2;
    }
}

1;
__END__

=head1 NAME

Robomari - Replace London.pm current pub minion with a perl script and a cronjob

=head1 METHODS

=head2 new

Moose supplied accessor

=head2 dispatch

Call with no arguments and it will just do the right thing

=head1 ACKNOWLEDGEMENTS

Thanks Ilmari for taking pub minionship off my hands allowing me to be even lazier.

That said, now I've written code, look what you've done!

=head1 AUTHOR

James Laver <cpan at jameslaver dot com>, former London.pm pub minion

=cut
