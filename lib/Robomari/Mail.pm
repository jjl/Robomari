package Robomari::Mail;

use Moose;
use Text::Template;
use FindBin;
use File::Finder;
use Path::Class qw(dir file);
use Robomari::Config;

has date => (
    is => 'ro',
    isa => 'Robomari::Date',
);

sub announce {
    $self->_send_mail('announce');
}

sub remind_1 {
    $self->_send_mail('remind_1');
}

sub remind_2 {
    $self->_send_mail('remind_2');
}

sub _send_mail {
    my ($self,$type) = @_;
    my $tpl = $self->_select_random_template($type);
    my $text = $tpl->_render_template($tpl);
    $self->_do_sendmail($text);
}

sub _do_sendmail {
    my ($self,$message) = @_;
    open(SENDMAIL,"|",$Robomari::Config::sendmail_path) or die("No sendmail at $Robomari::Config::sendmail_path");
    print SENDMAIL $message;
    close(SENDMAIL);
}

sub _select_random_template {
    my ($self,$type) = @_;
    #Open template dir
    my $dir = dir($FindBin::Bin,'tpl');
    #Check the $type subdir exists
    my $type_dir = $dir->subdir($type);
    die("$type dir not found") unless($type_dir);
    #Get a list of templates in the dir, including subdirs
    my @files = File::Finder->type('f')->in($type_dir->stringify);
    return $files[rand @files];
}

sub _render_template {
    my ($self,$template) = @_;
    my $tt = Text::Template->new(TYPE => 'FILE', SOURCE => $template);
    my %replacements = (
        social_date => $self->date->next_social,
    );
    return $tt->fill_in(HASH => \%replacements);
}

1;
__END__

=head1 NAME

Robomari::Mail - Handle mailing of announcements regarding London.pm socials

=head1 SYNOPSIS

 use Robomari::Mail;
 $mail = Robomari::Mail->new($datetime_of_next_social);
 #Send announce email
 $mail->announce;
 #And the reminder that it's this week
 $mail->remind_1;
 #And the reminder that it's today
 $mail->remind_2;

Of course if you do all that, emails will go on the wrong day. See L<Robomari>

=head1 METHODS

=head2 announce

Sends an announce email

=head2 remind_1

Sends a reminder email that the upcoming social is this week

=head2 remind_2

Sends a reminder email that the upcoming social is today

=head1 AUTHOR

James Laver <cpan at jameslaver dot com> - former London.pm pub minion

=cut