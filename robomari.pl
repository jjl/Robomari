#!/usr/bin/env perl

use lib 'lib';
use Robomari;

Robomari->new->dispatch();

__END__

=head1 NAME

Robomari - Replace London.pm current pub minion with a perl script and a cronjob

=head1 USAGE

 ./robomari.pl

=head1 ACKNOWLEDGEMENTS

Thanks Ilmari for taking pub minionship off my hands allowing me to be even lazier.

That said, now I've written code, look what you've done!

=head1 AUTHOR

James Laver <cpan at jameslaver dot com>, former London.pm pub minion

=cut