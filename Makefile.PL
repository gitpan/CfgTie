#!/usr/bin/perl -w
#Copyright 1998-1999, Randall Maas.  All rights reserved.  This program is free
#software; you can redistribute it and/or modify it under the same terms as
#PERL itself.

#This is the magical make maker.  It does even more complicated stuff than
#normal becauseI use TeXInfo and want it linked in.

use ExtUtils::MakeMaker;

#see lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

use Cwd;
my $dir = cwd();
$dir =~ s/^.*\/([^\/]+)$/$1/;

$VERSION="0.0";
if ($dir =~ /-([\d\.]+)$/) {$VERSION=$1;}
if ($dir =~ /^(.+)-[\d\.]+$/) {$ModName="$1";}

my $Pfiles="lib/$ModName/". join(".pm lib/$ModName/",
        'TieRCService','Cfgfile', 'CfgArgs',
        'TieAliases', 'TieGeneric','TieGroup','TieHost',  'TieNamed','TieNet',
        'TiePh',      'TieProto',  'TieServ', 'TieShadow','TieUser').'.pm';

sub MY::postamble
{
   "\n#This assumes, of course, that you have these tools installed...\n".
   "$ModName"."_toc.html: $ModName.tex $Pfiles Intro.tex\n".
   "\tmake all -Clib/$ModName\n".
   "\tmake all -Cbin\n".
   "\tprj2texi MANIFEST > CodeMenu.tex\n".
   "\ttexi2html -glossary -split_node -menu $ModName.tex\n\n".
   "texi: $ModName"."_toc.html \n".
   "\t../../tup.pl $ModName\n\n".
   "tarball: ../$dir\n".
   "\t tar cv --gzip -C .. -f../$dir-`date +%Y%m%d`.tar.gz $dir --exclude *,v --exclude blib -S\n\n";
}


#My script files
opendir D, 'bin';
my ($A,$b,@_Scripts)=readdir D;
closedir D;
my @Scripts;
foreach my $I (@_Scripts)
{
   if ($I=~/makefile/i) {next;}
   if ($I =~/\.tex$/i) {next;}
   push @Scripts, "bin/$I";
}


WriteMakefile(
    'NAME'      => $ModName, #'-Tools',
    'dist'    => {COMPRESS=> 'gzip -9f', SUFFIX=>'gz', 
                  POSTOP => 'mv $(DISTNAME)-$(VERSION).tar.gz ../'
                  },
    'linkext' => {LINKTYPE => '' }, 
    'clean'   => {FILES => "*% *.html *~ www-* .htp* .htg*"},
    VERSION => $VERSION,
    'VERSION_FROM' => '', # finds $VERSION
    'EXE_FILES' => [@Scripts],
    'MAN1PODS'  => {map {my $a=$_; s/^bin\//.\/blib\/man1\//; $a,"$_.\$(MAN1EXT)";} @Scripts},
);


require ExtUtils::Manifest;
ExtUtils::Manifest::mkmanifest();
