#!perl
use strict;
use warnings;

use Path::Tiny qw( path tempdir );    # dev-perl/Path-Tiny
use Term::ANSIColor qw( colored colorstrip );

sub einfo;
sub eerror;
sub ewarn;
sub green;
sub red;
sub yellow;

my $version = do {
    open my $fh, '-|', 'bash', 'libexec/version'
      or die "can't spawn bash for version";
    scalar <$fh>;
};
chomp $version;

my $output_name = "gentoo-perl-helpers-$version";
my $tar_name    = "$output_name.tar";
my $xz_name     = "$tar_name.xz";
my $lzip_name   = "$tar_name.lz";
my $manifest    = path( 'maint', 'MANIFEST' );

einfo "Using " . green($xz_name) . " for (xz)tarball";
if ( path($xz_name)->exists ) {
    eerror "Path " . red($xz_name) . " already exists";
}
einfo "Using " . green($lzip_name) . " for (lzip)tarball";
if ( path($lzip_name)->exists ) {
    eerror "Path " . red($lzip_name) . " already exists";
}
my $tempdir = tempdir( TEMPLATE => "make_release.XXXXXXX" );

tar_manifest( $manifest, path( $tempdir, $tar_name ), );

xz_compress(
    path( $tempdir, $tar_name ),
    path( $tempdir, $xz_name ),
    path( '.',      $xz_name )
);

lzip_compress(
    path( $tempdir, $tar_name ),
    path( $tempdir, $lzip_name ),
    path( '.',      $lzip_name )
);

sub green  { colored( ['bold green'],  $_[0] ) }
sub red    { colored( ['bold red'],    $_[0] ) }
sub yellow { colored( ['bold yellow'], $_[0] ) }
sub einfo  { warn green("*") . " " . $_[0] . "\n" }
sub ewarn  { warn yellow("*") . " " . $_[0] . "\n" }

sub eerror {
    warn red("*") . " " . $_[0] . "\n";
    die colorstrip $_[0];
}

sub tar_manifest {
    my ( $manifest, $dest ) = @_;
    einfo "Archiving files from " . green($manifest) . " to " . green($dest);

    system(
        'tar',                    '-cf',
        $dest,                    '--sort=name',
        '--no-xattrs',            '--no-acls',
        '--no-selinux',           '--exclude-vcs',
        '--exclude-vcs-ignores',  '--dereference',
        '-v',                     '--totals',
        "--files-from=$manifest", "--verbatim-files-from"
      ) == 0
      or eerror "tar did not exit cleanly, $? $!";
}

sub xz_compress {
    my ( $source, $dest, $final_dest ) = @_;
    einfo "Compressing "
      . green($source) . "\n"
      . "           to "
      . green($dest);

    delete $ENV{XZ_DEFAULTLS};
    my $pid = fork;
    my $ofh = path($dest)->openw_raw;

    if ( $pid == 0 ) {
        close STDOUT;
        open STDOUT, '>', path($dest) or eerror "Can't open write target";
        system(
            'xz', '-vv9e',
            '--memlimit-compress=5G',
'--lzma2=dict=512KiB,lc=3,lp=0,pb=2,mode=normal,nice=273,mf=bt4,depth=2048',
            '--memlimit-decompress=1M',    # low threshold for decompressing.
            '-k', '--stdout',
            path( $tempdir, $tar_name )
          ) == 0
          or eerror "xz did not exit cleanly, $? $!";
        exit 0;
    }
    elsif ( defined $pid ) {
        waitpid $pid, 0;
        $? == 0 or eerror "xz worker died, $? $!";
    }
    else {
        eerror "Can't fork, $!";
    }

    einfo "Copying " . green($dest) . "\n" . "       to " . green($final_dest);

    path($dest)->copy($final_dest);

}

sub lzip_compress {
    my ( $source, $dest, $final_dest ) = @_;
    einfo "Compressing "
      . green($source) . "\n"
      . "           to "
      . green($dest);

    system(
        'lzip', '-vvvv9', '-s',    '512KiB', '-k',
        '-m',   '273',    $source, '-o',     $dest
      ) == 0
      or eerror "lzip did not exit cleanly, $? $!";

    einfo "Copying " . green($dest) . "\n" . "       to " . green($final_dest);

    path($dest)->copy($final_dest);
}
