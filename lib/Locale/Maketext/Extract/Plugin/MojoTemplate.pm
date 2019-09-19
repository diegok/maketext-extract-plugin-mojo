package Locale::Maketext::Extract::Plugin::MojoTemplate;
# ABSTRACT: Mojo templates format parser plugin for Locale::Maketext::Extract

use strict;
use base qw(Locale::Maketext::Extract::Plugin::Base);

sub file_types {[qw( ep )]}

sub extract {
    my ($self, $content) = (shift, shift);

    # Match text strings handling embeded quotemarks
    #TODO: handle q|| qq|| q() etc...
    my $re_str = qr/
        (?<quotemark>") (?<text>(?: \\" | [^"] )*) "
        |
        (?<quotemark>') (?<text>(?: \\' | [^'] )*) '
    /x;

    my $line = 1;
    while ( $content =~ /\G( .*? (?:^\s*\%=? \s* ([^\n]+) | <\%=? \s* (.+?) \s* \%>) )/xsmg ) {
        my $code = $2 || $3;
        $line += ( () = ( $1 =~ /\n/g ) );
        while ( $code =~ /\G.*?\bl \s* \( \s* $re_str \s* (?:,\s*(?<args>.+?))? \)/xsmg ) {
            my ($qmark, $text, $args) = map { $+{$_} } qw/ quotemark text args /;
            $text =~ s/\\$qmark/$qmark/g;
            $self->add_entry($text,$line,$args)
        }
    }

    return;
}

1;
