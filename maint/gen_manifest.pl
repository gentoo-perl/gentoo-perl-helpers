#!perl
use 5.020;
use strict;
use warnings;


use Git::Wrapper;
use Path::Tiny qw( path );

my $git = Git::Wrapper->new('.');
my $manifest = path( __FILE__ )->sibling('MANIFEST')->openw_raw;
my $LF = chr(0x0A);

my @out;

for my $i ( $git->ls_files('--exclude-standard', '--full-name') ) {
  next if $i =~ /\.orig$/;
  next if $i =~ /^maint\//;
  next if $i =~ /-volatile/;
  next if $i =~ /(\A|\/)[.]gitignore\z/;
  $manifest->printf("%s${LF}", $i);
}

