package Locale::Maketext::Extract::Plugin::MojoTemplate;
use strict;
use base qw(Locale::Maketext::Extract::Plugin::Base);

# ABSTRACT: Mojo templates format parser plugin for Locale::Maketext::Extract

sub file_types {
    return [qw( ep )]
}

sub extract {
    my $self = shift;
    local $_ = shift;

    my $line = 1;

    while ( /\G(.*?(?:^\s*\%=?([^\n]+)|<\%=?(.+?)\%>))/smg ) {
        my $code = $2 || $3;
        $line += ( () = ( $1 =~ /\n/g ) );
        if ( $code =~ /l \s* \( \s* ['"](.+?)['"] \s* (?:,\s*(.+?)) \)/xsm ) {
            $self->add_entry($1,$line,$2)
        }
    }

    return;
}

1;
