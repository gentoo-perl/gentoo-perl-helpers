#!perl
use strict;
use warnings;

use Git::Wrapper;
use Data::Dump qw(pp);
use Path::Tiny qw(path);

my $gw = Git::Wrapper->new('.');

local $ENV{TZ} = 'UTC';

my $RS = chr(0x1E);
my $US = chr(0x1F);

my $RS_git = '%x1E';
my $US_git = '%x1F';

my $git_format = $RS_git . (
    join $US_git,
    (
        '%D',     # decoration
        '%cd',    # commit timestamp
        '%N',     # notes
        '%B',     # raw, unwrapped subject + body
    )
) . $RS_git;

my $buf = join qq[\n],
  $gw->RUN(
    'log',
    '--date=format-local:%Y-%m-%d/%H',
    '--format=format:' . $git_format
  );

my @notes;
my $tag = {};
my $tip_time;
my $fh = path('./Changes')->openw_utf8;
( $tag->{tag}, ) = map { $_ =~ /echo\s*(\S*)\s*/; $1 }
  grep /^echo/, path('./libexec/version')->lines_utf8( { chomp => 1 } );

while ( $buf =~ /\A ( [^${RS}]* ${RS} ([^${RS}]*) ${RS} )/x ) {
    my $match   = $1;
    my $content = $2;
    substr( $buf, 0, length $match, "" );    # eat it
    my ( $decoration, $time, $note, $body ) = split $US, $content;

    exists $tag->{time} or $tag->{time} = $time;

    if ( $decoration =~ /^tag: (.*)$/ ) {
        print_notes( $tag, \@notes );
        $tag = { tag => $1, time => $time };
        @notes = ();
    }
    push @notes, extract_note_lines( $body . "\n" . $note );
}

print_notes( $tag, \@notes );

sub print_notes {
    my ( $tag, $notes ) = @_;
    if ($tag) {
        for my $fd ( *STDOUT, $fh ) {
            $fd->printf( "%s %s\n", $tag->{tag}, $tag->{time} );
        }
    }
    for ( sort @{ $notes || [] } ) {
        for my $fd ( *STDOUT, $fh ) {
            $fd->printf( " - %s", $_ );
        }
    }
    if ( $tag or @{$notes} ) {
        for my $fd ( *STDOUT, $fh ) {
            $fd->print("\n");
        }
    }
}

sub extract_note_lines {
    my ($body) = @_;
    my @out;
    while ( $body =~ /\A(.*changelog:\s([^\n]+\n))/msx ) {
        my $match   = $1;
        my $content = $2;
        substr( $body, 0, length $match, '' );    # eat it
        push @out, $content;
    }
    return @out;
}
