package Robomari::Date;

use Moose;

has today => (
    isa => 'DateTime',
    is => 'ro',
    lazy_build => 1,
);

has next_social => (
    isa => 'DateTime',
    is => 'ro',
    lazy_build => 1,
);

sub _build_today {
    DateTime->today;
}

sub _build_next_social {
    my ($self) = @_;
    $this_month = $self->today->truncate(to => 'month');
    $social_this_month = $self->_get_social_in_month($this_month);
    return $social_this_month if ($self->today->compare($social_this_month) < 1);
    $next_month = $this_month->add(months => 1);
    $social_next_month = $self->_get_social_in_month($next_month);
    return $social_next_month;
}

sub _get_social_in_month {
    my ($self,$dt) = @_;
    $dt->dow < 4 ?
        #It's monday - wednesday, just add a couple of days on
        $dt->add(days => 4 - $dt->dow) :
        #It's thursday - sunday, add another week on (giving it max date of the 8th)
        $dt->add(days => 11 - $dt->dow);
}

sub is_announce {
    my ($self) = @_;
    !$self->next_social->subtract(days => 14)->compare($self->today);
}

sub is_reminder {
    my ($self) = @_;
    !$self->next_social->subtract(days => 3)->compare($self->today);
}

sub is_social {
    my ($self) = @_;
    !$self->next_social->compare($self->today);
}

sub is_social_heretical {
    my ($self) = @_;
    return ($self->next_social->truncate(to => 'month')->dow == 4);
}

1;
__END__

=head1 NAME

Robomari::Date - Calculations regarding London.pm meeting dates

=head1 METHODS

=head2 new

Moose supplied accessor

=head2 is_announce :: Bool

Returns whether today is a good day to announce the next social

=head2 is_reminder :: Bool

Return whether today is a good day to remind people the social is this week

=head2 is_social :: Bool

Return whether today is the day of the social

=head2 is_social_heretical :: Bool

Return whether the next social will be heretical and not follow the orthodox way

=head1 ACKNOWLEDGEMENTS

No thanks to Greg McCarroll for making this take 20 minutes to write instead of two.

=head1 AUTHOR

James Laver <cpan at jameslaver dot com>, former London.pm pub minion

=cut