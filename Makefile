# This Makefile is for the CfgTie extension to perl.
#
# It was generated automatically by MakeMaker version
# 5.4002 (Revision: 1.211) from the contents of
# Makefile.PL. Don't edit this file, edit Makefile.PL instead.
#
#	ANY CHANGES MADE HERE WILL BE LOST!
#
#   MakeMaker Parameters:

#	EXE_FILES => [q[bin/CfgAliases], q[bin/CfgNamed], q[bin/CfgAliases,v]]
#	MAN1PODS => { bin/CfgAliases=>q[./blib/man1/CfgAliases.$(MAN1EXT)], bin/CfgAliases,v=>q[./blib/man1/CfgAliases,v.$(MAN1EXT)], bin/CfgNamed=>q[./blib/man1/CfgNamed.$(MAN1EXT)] }
#	NAME => q[CfgTie]
#	VERSION => q[0.2]
#	VERSION_FROM => q[]
#	clean => { FILES=>q[*% *.html *~ www-* .htp* .htg*] }
#	dist => { COMPRESS=>q[gzip -9f], POSTOP=>q[mv $(DISTNAME)-$(VERSION).tar.gz ../], SUFFIX=>q[gz] }
#	linkext => { LINKTYPE=>q[] }

# --- MakeMaker post_initialize section:


# --- MakeMaker const_config section:

# These definitions are from config.sh (via /usr/lib/perl5/i386-linux/5.00401/Config.pm)

# They may have been overridden via Makefile.PL or on the command line
AR = ar
CC = cc
CCCDLFLAGS = -fpic
CCDLFLAGS = -rdynamic
DLEXT = so
DLSRC = dl_dlopen.xs
LD = cc
LDDLFLAGS = -shared -L/usr/local/lib
LDFLAGS =  -L/usr/local/lib
LIBC = 
LIB_EXT = .a
OBJ_EXT = .o
RANLIB = :
SO = so
EXE_EXT = 


# --- MakeMaker constants section:
AR_STATIC_ARGS = cr
NAME = CfgTie
DISTNAME = CfgTie
NAME_SYM = CfgTie
VERSION = 0.2
VERSION_SYM = 0_2
XS_VERSION = 0.2
INST_BIN = ./blib/bin
INST_EXE = ./blib/script
INST_LIB = ./blib/lib
INST_ARCHLIB = ./blib/arch
INST_SCRIPT = ./blib/script
PREFIX = /usr
INSTALLDIRS = site
INSTALLPRIVLIB = $(PREFIX)/lib/perl5
INSTALLARCHLIB = $(PREFIX)/lib/perl5/i386-linux/5.00401
INSTALLSITELIB = $(PREFIX)/lib/perl5/site_perl
INSTALLSITEARCH = $(PREFIX)/lib/perl5/site_perl/i386-linux
INSTALLBIN = $(PREFIX)/bin
INSTALLSCRIPT = $(PREFIX)/bin
PERL_LIB = /usr/lib/perl5
PERL_ARCHLIB = /usr/lib/perl5/i386-linux/5.00401
SITELIBEXP = /usr/lib/perl5/site_perl
SITEARCHEXP = /usr/lib/perl5/site_perl/i386-linux
LIBPERL_A = libperl.a
FIRST_MAKEFILE = Makefile
MAKE_APERL_FILE = Makefile.aperl
PERLMAINCC = $(CC)
PERL_INC = /usr/lib/perl5/i386-linux/5.00401/CORE
PERL = /usr/bin/perl
FULLPERL = /usr/bin/perl

VERSION_MACRO = VERSION
DEFINE_VERSION = -D$(VERSION_MACRO)=\"$(VERSION)\"
XS_VERSION_MACRO = XS_VERSION
XS_DEFINE_VERSION = -D$(XS_VERSION_MACRO)=\"$(XS_VERSION)\"

MAKEMAKER = /usr/lib/perl5/ExtUtils/MakeMaker.pm
MM_VERSION = 5.4002

# FULLEXT = Pathname for extension directory (eg Foo/Bar/Oracle).
# BASEEXT = Basename part of FULLEXT. May be just equal FULLEXT. (eg Oracle)
# ROOTEXT = Directory part of FULLEXT with leading slash (eg /DBD)  !!! Deprecated from MM 5.32  !!!
# PARENT_NAME = NAME without BASEEXT and no trailing :: (eg Foo::Bar)
# DLBASE  = Basename part of dynamic library. May be just equal BASEEXT.
FULLEXT = CfgTie
BASEEXT = CfgTie
DLBASE = $(BASEEXT)
VERSION_FROM = 
OBJECT = 
LDFROM = $(OBJECT)
LINKTYPE = dynamic

# Handy lists of source code files:
XS_FILES= 
C_FILES = 
O_FILES = 
H_FILES = 
MAN1PODS = bin/CfgAliases \
	bin/CfgAliases,v \
	bin/CfgNamed
MAN3PODS = lib/CfgTie/CfgArgs.pm \
	lib/CfgTie/Cfgfile.pm \
	lib/CfgTie/TieAliases.pm \
	lib/CfgTie/TieGeneric.pm \
	lib/CfgTie/TieGroup.pm \
	lib/CfgTie/TieHost.pm \
	lib/CfgTie/TieNamed.pm \
	lib/CfgTie/TieNet.pm \
	lib/CfgTie/TiePh.pm \
	lib/CfgTie/TieProto.pm \
	lib/CfgTie/TieRCService.pm \
	lib/CfgTie/TieServ.pm \
	lib/CfgTie/TieShadow.pm \
	lib/CfgTie/TieUser.pm \
	lib/CfgTie/filever.pm
INST_MAN1DIR = ./blib/man1
INSTALLMAN1DIR = /usr/man/man1
MAN1EXT = 1
INST_MAN3DIR = ./blib/man3
INSTALLMAN3DIR = $(PREFIX)/lib/perl5/man/man3
MAN3EXT = 3

# work around a famous dec-osf make(1) feature(?):
makemakerdflt: all

.SUFFIXES: .xs .c .C .cpp .cxx .cc $(OBJ_EXT)

# Nick wanted to get rid of .PRECIOUS. I don't remember why. I seem to recall, that
# some make implementations will delete the Makefile when we rebuild it. Because
# we call false(1) when we rebuild it. So make(1) is not completely wrong when it
# does so. Our milage may vary.
# .PRECIOUS: Makefile    # seems to be not necessary anymore

.PHONY: all config static dynamic test linkext manifest

# Where is the Config information that we are using/depend on
CONFIGDEP = $(PERL_ARCHLIB)/Config.pm $(PERL_INC)/config.h

# Where to put things:
INST_LIBDIR      = $(INST_LIB)
INST_ARCHLIBDIR  = $(INST_ARCHLIB)

INST_AUTODIR     = $(INST_LIB)/auto/$(FULLEXT)
INST_ARCHAUTODIR = $(INST_ARCHLIB)/auto/$(FULLEXT)

INST_STATIC  =
INST_DYNAMIC =
INST_BOOT    =

EXPORT_LIST = 

PERL_ARCHIVE = 

TO_INST_PM = lib/CfgTie/CfgArgs.pm \
	lib/CfgTie/CfgArgs.pm,v \
	lib/CfgTie/Cfgfile.pm \
	lib/CfgTie/Cfgfile.pm,v \
	lib/CfgTie/TieAliases.pm \
	lib/CfgTie/TieAliases.pm,v \
	lib/CfgTie/TieGeneric.pm \
	lib/CfgTie/TieGeneric.pm,v \
	lib/CfgTie/TieGroup.pm \
	lib/CfgTie/TieGroup.pm,v \
	lib/CfgTie/TieHost.pm \
	lib/CfgTie/TieHost.pm,v \
	lib/CfgTie/TieNamed.pm \
	lib/CfgTie/TieNamed.pm,v \
	lib/CfgTie/TieNet.pm \
	lib/CfgTie/TieNet.pm,v \
	lib/CfgTie/TiePh.pm \
	lib/CfgTie/TiePh.pm,v \
	lib/CfgTie/TieProto.pm \
	lib/CfgTie/TieProto.pm,v \
	lib/CfgTie/TieRCService.pm \
	lib/CfgTie/TieRCService.pm,v \
	lib/CfgTie/TieServ.pm \
	lib/CfgTie/TieServ.pm,v \
	lib/CfgTie/TieShadow.pm \
	lib/CfgTie/TieShadow.pm,v \
	lib/CfgTie/TieUser.pm \
	lib/CfgTie/TieUser.pm,v \
	lib/CfgTie/filever.pm \
	lib/CfgTie/filever.pm,v \
	lib/CfgTie/makefile \
	lib/CfgTie/tmp

PM_TO_BLIB = lib/CfgTie/TieGroup.pm \
	$(INST_LIB)/CfgTie/TieGroup.pm \
	lib/CfgTie/filever.pm,v \
	$(INST_LIB)/CfgTie/filever.pm,v \
	lib/CfgTie/Cfgfile.pm \
	$(INST_LIB)/CfgTie/Cfgfile.pm \
	lib/CfgTie/TieGroup.pm,v \
	$(INST_LIB)/CfgTie/TieGroup.pm,v \
	lib/CfgTie/Cfgfile.pm,v \
	$(INST_LIB)/CfgTie/Cfgfile.pm,v \
	lib/CfgTie/makefile \
	$(INST_LIB)/CfgTie/makefile \
	lib/CfgTie/TieProto.pm \
	$(INST_LIB)/CfgTie/TieProto.pm \
	lib/CfgTie/TieProto.pm,v \
	$(INST_LIB)/CfgTie/TieProto.pm,v \
	lib/CfgTie/TiePh.pm \
	$(INST_LIB)/CfgTie/TiePh.pm \
	lib/CfgTie/TiePh.pm,v \
	$(INST_LIB)/CfgTie/TiePh.pm,v \
	lib/CfgTie/CfgArgs.pm \
	$(INST_LIB)/CfgTie/CfgArgs.pm \
	lib/CfgTie/CfgArgs.pm,v \
	$(INST_LIB)/CfgTie/CfgArgs.pm,v \
	lib/CfgTie/TieGeneric.pm \
	$(INST_LIB)/CfgTie/TieGeneric.pm \
	lib/CfgTie/TieHost.pm \
	$(INST_LIB)/CfgTie/TieHost.pm \
	lib/CfgTie/TieUser.pm \
	$(INST_LIB)/CfgTie/TieUser.pm \
	lib/CfgTie/TieGeneric.pm,v \
	$(INST_LIB)/CfgTie/TieGeneric.pm,v \
	lib/CfgTie/TieHost.pm,v \
	$(INST_LIB)/CfgTie/TieHost.pm,v \
	lib/CfgTie/TieServ.pm \
	$(INST_LIB)/CfgTie/TieServ.pm \
	lib/CfgTie/TieUser.pm,v \
	$(INST_LIB)/CfgTie/TieUser.pm,v \
	lib/CfgTie/TieAliases.pm \
	$(INST_LIB)/CfgTie/TieAliases.pm \
	lib/CfgTie/TieServ.pm,v \
	$(INST_LIB)/CfgTie/TieServ.pm,v \
	lib/CfgTie/tmp \
	$(INST_LIB)/CfgTie/tmp \
	lib/CfgTie/TieAliases.pm,v \
	$(INST_LIB)/CfgTie/TieAliases.pm,v \
	lib/CfgTie/TieNamed.pm \
	$(INST_LIB)/CfgTie/TieNamed.pm \
	lib/CfgTie/TieRCService.pm \
	$(INST_LIB)/CfgTie/TieRCService.pm \
	lib/CfgTie/TieShadow.pm \
	$(INST_LIB)/CfgTie/TieShadow.pm \
	lib/CfgTie/TieNet.pm \
	$(INST_LIB)/CfgTie/TieNet.pm \
	lib/CfgTie/TieNamed.pm,v \
	$(INST_LIB)/CfgTie/TieNamed.pm,v \
	lib/CfgTie/TieRCService.pm,v \
	$(INST_LIB)/CfgTie/TieRCService.pm,v \
	lib/CfgTie/TieShadow.pm,v \
	$(INST_LIB)/CfgTie/TieShadow.pm,v \
	lib/CfgTie/TieNet.pm,v \
	$(INST_LIB)/CfgTie/TieNet.pm,v \
	lib/CfgTie/filever.pm \
	$(INST_LIB)/CfgTie/filever.pm


# --- MakeMaker tool_autosplit section:

# Usage: $(AUTOSPLITFILE) FileToSplit AutoDirToSplitInto
AUTOSPLITFILE = $(PERL) "-I$(PERL_ARCHLIB)" "-I$(PERL_LIB)" -e 'use AutoSplit;autosplit($$ARGV[0], $$ARGV[1], 0, 1, 1) ;'


# --- MakeMaker tool_xsubpp section:


# --- MakeMaker tools_other section:

SHELL = /bin/sh
CHMOD = chmod
CP = cp
LD = cc
MV = mv
NOOP = $(SHELL) -c true
RM_F = rm -f
RM_RF = rm -rf
TEST_F = test -f
TOUCH = touch
UMASK_NULL = umask 0
DEV_NULL = > /dev/null 2>&1

# The following is a portable way to say mkdir -p
# To see which directories are created, change the if 0 to if 1
MKPATH = $(PERL) -I$(PERL_ARCHLIB) -I$(PERL_LIB) -MExtUtils::Command -e mkpath

# This helps us to minimize the effect of the .exists files A yet
# better solution would be to have a stable file in the perl
# distribution with a timestamp of zero. But this solution doesn't
# need any changes to the core distribution and works with older perls
EQUALIZE_TIMESTAMP = $(PERL) -I$(PERL_ARCHLIB) -I$(PERL_LIB) -MExtUtils::Command -e eqtime

# Here we warn users that an old packlist file was found somewhere,
# and that they should call some uninstall routine
WARN_IF_OLD_PACKLIST = $(PERL) -we 'exit unless -f $$ARGV[0];' \
-e 'print "WARNING: I have found an old package in\n";' \
-e 'print "\t$$ARGV[0].\n";' \
-e 'print "Please make sure the two installations are not conflicting\n";'

UNINST=0
VERBINST=1

MOD_INSTALL = $(PERL) -I$(INST_LIB) -I$(PERL_LIB) -MExtUtils::Install \
-e "install({@ARGV},'$(VERBINST)',0,'$(UNINST)');"

DOC_INSTALL = $(PERL) -e '$$\="\n\n";' \
-e 'print "=head2 ", scalar(localtime), ": C<", shift, ">", " L<", shift, ">";' \
-e 'print "=over 4";' \
-e 'while (defined($$key = shift) and defined($$val = shift)){print "=item *";print "C<$$key: $$val>";}' \
-e 'print "=back";'

UNINSTALL =   $(PERL) -MExtUtils::Install \
-e 'uninstall($$ARGV[0],1,1); print "\nUninstall is deprecated. Please check the";' \
-e 'print " packlist above carefully.\n  There may be errors. Remove the";' \
-e 'print " appropriate files manually.\n  Sorry for the inconveniences.\n"'


# --- MakeMaker dist section:

DISTVNAME = $(DISTNAME)-$(VERSION)
TAR  = tar
TARFLAGS = cvf
ZIP  = zip
ZIPFLAGS = -r
COMPRESS = gzip -9f
SUFFIX = gz
SHAR = shar
PREOP = @$(NOOP)
POSTOP = mv $(DISTNAME)-$(VERSION).tar.gz ../
TO_UNIX = @$(NOOP)
CI = ci -u
RCS_LABEL = rcs -Nv$(VERSION_SYM): -q
DIST_CP = best
DIST_DEFAULT = tardist


# --- MakeMaker macro section:


# --- MakeMaker depend section:


# --- MakeMaker cflags section:


# --- MakeMaker const_loadlibs section:


# --- MakeMaker const_cccmd section:


# --- MakeMaker post_constants section:


# --- MakeMaker pasthru section:

PASTHRU = LIB="$(LIB)"\
	LIBPERL_A="$(LIBPERL_A)"\
	LINKTYPE="$(LINKTYPE)"\
	PREFIX="$(PREFIX)"\
	OPTIMIZE="$(OPTIMIZE)"


# --- MakeMaker c_o section:


# --- MakeMaker xs_c section:


# --- MakeMaker xs_o section:


# --- MakeMaker top_targets section:

#all ::	config $(INST_PM) subdirs linkext manifypods

all :: pure_all manifypods
	@$(NOOP)

pure_all :: config pm_to_blib subdirs linkext
	@$(NOOP)

subdirs :: $(MYEXTLIB)
	@$(NOOP)

config :: Makefile $(INST_LIBDIR)/.exists
	@$(NOOP)

config :: $(INST_ARCHAUTODIR)/.exists
	@$(NOOP)

config :: $(INST_AUTODIR)/.exists
	@$(NOOP)

config :: Version_check
	@$(NOOP)


$(INST_AUTODIR)/.exists :: /usr/lib/perl5/i386-linux/5.00401/CORE/perl.h
	@$(MKPATH) $(INST_AUTODIR)
	@$(EQUALIZE_TIMESTAMP) /usr/lib/perl5/i386-linux/5.00401/CORE/perl.h $(INST_AUTODIR)/.exists

	-@$(CHMOD) 755 $(INST_AUTODIR)

$(INST_LIBDIR)/.exists :: /usr/lib/perl5/i386-linux/5.00401/CORE/perl.h
	@$(MKPATH) $(INST_LIBDIR)
	@$(EQUALIZE_TIMESTAMP) /usr/lib/perl5/i386-linux/5.00401/CORE/perl.h $(INST_LIBDIR)/.exists

	-@$(CHMOD) 755 $(INST_LIBDIR)

$(INST_ARCHAUTODIR)/.exists :: /usr/lib/perl5/i386-linux/5.00401/CORE/perl.h
	@$(MKPATH) $(INST_ARCHAUTODIR)
	@$(EQUALIZE_TIMESTAMP) /usr/lib/perl5/i386-linux/5.00401/CORE/perl.h $(INST_ARCHAUTODIR)/.exists

	-@$(CHMOD) 755 $(INST_ARCHAUTODIR)

config :: $(INST_MAN1DIR)/.exists
	@$(NOOP)


$(INST_MAN1DIR)/.exists :: /usr/lib/perl5/i386-linux/5.00401/CORE/perl.h
	@$(MKPATH) $(INST_MAN1DIR)
	@$(EQUALIZE_TIMESTAMP) /usr/lib/perl5/i386-linux/5.00401/CORE/perl.h $(INST_MAN1DIR)/.exists

	-@$(CHMOD) 755 $(INST_MAN1DIR)

config :: $(INST_MAN3DIR)/.exists
	@$(NOOP)


$(INST_MAN3DIR)/.exists :: /usr/lib/perl5/i386-linux/5.00401/CORE/perl.h
	@$(MKPATH) $(INST_MAN3DIR)
	@$(EQUALIZE_TIMESTAMP) /usr/lib/perl5/i386-linux/5.00401/CORE/perl.h $(INST_MAN3DIR)/.exists

	-@$(CHMOD) 755 $(INST_MAN3DIR)

help:
	perldoc ExtUtils::MakeMaker

Version_check:
	@$(PERL) -I$(PERL_ARCHLIB) -I$(PERL_LIB) \
		-MExtUtils::MakeMaker=Version_check \
		-e "Version_check('$(MM_VERSION)')"


# --- MakeMaker linkext section:

linkext :: 
	@$(NOOP)


# --- MakeMaker dlsyms section:


# --- MakeMaker dynamic section:

## $(INST_PM) has been moved to the all: target.
## It remains here for awhile to allow for old usage: "make dynamic"
#dynamic :: Makefile $(INST_DYNAMIC) $(INST_BOOT) $(INST_PM)
dynamic :: Makefile $(INST_DYNAMIC) $(INST_BOOT)
	@$(NOOP)


# --- MakeMaker dynamic_bs section:

BOOTSTRAP =


# --- MakeMaker dynamic_lib section:


# --- MakeMaker static section:

## $(INST_PM) has been moved to the all: target.
## It remains here for awhile to allow for old usage: "make static"
#static :: Makefile $(INST_STATIC) $(INST_PM)
static :: Makefile $(INST_STATIC)
	@$(NOOP)


# --- MakeMaker static_lib section:


# --- MakeMaker manifypods section:
POD2MAN_EXE = /usr/bin/pod2man
POD2MAN = $(PERL) -we '%m=@ARGV;for (keys %m){' \
-e 'next if -e $$m{$$_} && -M $$m{$$_} < -M $$_ && -M $$m{$$_} < -M "Makefile";' \
-e 'print "Manifying $$m{$$_}\n";' \
-e 'system(qq[$$^X ].q["-I$(PERL_ARCHLIB)" "-I$(PERL_LIB)" $(POD2MAN_EXE) ].qq[$$_>$$m{$$_}])==0 or warn "Couldn\047t install $$m{$$_}\n";' \
-e 'chmod 0644, $$m{$$_} or warn "chmod 644 $$m{$$_}: $$!\n";}'

manifypods : bin/CfgAliases \
	bin/CfgAliases,v \
	bin/CfgNamed \
	lib/CfgTie/TieGeneric.pm \
	lib/CfgTie/TieGroup.pm \
	lib/CfgTie/TieHost.pm \
	lib/CfgTie/Cfgfile.pm \
	lib/CfgTie/TieUser.pm \
	lib/CfgTie/TieServ.pm \
	lib/CfgTie/TieAliases.pm \
	lib/CfgTie/TieProto.pm \
	lib/CfgTie/TieNamed.pm \
	lib/CfgTie/TieShadow.pm \
	lib/CfgTie/TieRCService.pm \
	lib/CfgTie/TieNet.pm \
	lib/CfgTie/TiePh.pm \
	lib/CfgTie/filever.pm \
	lib/CfgTie/CfgArgs.pm
	@$(POD2MAN) \
	bin/CfgAliases \
	./blib/man1/CfgAliases.$(MAN1EXT) \
	bin/CfgAliases,v \
	./blib/man1/CfgAliases,v.$(MAN1EXT) \
	bin/CfgNamed \
	./blib/man1/CfgNamed.$(MAN1EXT) \
	lib/CfgTie/TieGeneric.pm \
	$(INST_MAN3DIR)/CfgTie::TieGeneric.$(MAN3EXT) \
	lib/CfgTie/TieGroup.pm \
	$(INST_MAN3DIR)/CfgTie::TieGroup.$(MAN3EXT) \
	lib/CfgTie/TieHost.pm \
	$(INST_MAN3DIR)/CfgTie::TieHost.$(MAN3EXT) \
	lib/CfgTie/Cfgfile.pm \
	$(INST_MAN3DIR)/CfgTie::Cfgfile.$(MAN3EXT) \
	lib/CfgTie/TieUser.pm \
	$(INST_MAN3DIR)/CfgTie::TieUser.$(MAN3EXT) \
	lib/CfgTie/TieServ.pm \
	$(INST_MAN3DIR)/CfgTie::TieServ.$(MAN3EXT) \
	lib/CfgTie/TieAliases.pm \
	$(INST_MAN3DIR)/CfgTie::TieAliases.$(MAN3EXT) \
	lib/CfgTie/TieProto.pm \
	$(INST_MAN3DIR)/CfgTie::TieProto.$(MAN3EXT) \
	lib/CfgTie/TieNamed.pm \
	$(INST_MAN3DIR)/CfgTie::TieNamed.$(MAN3EXT) \
	lib/CfgTie/TieShadow.pm \
	$(INST_MAN3DIR)/CfgTie::TieShadow.$(MAN3EXT) \
	lib/CfgTie/TieRCService.pm \
	$(INST_MAN3DIR)/CfgTie::TieRCService.$(MAN3EXT) \
	lib/CfgTie/TieNet.pm \
	$(INST_MAN3DIR)/CfgTie::TieNet.$(MAN3EXT) \
	lib/CfgTie/TiePh.pm \
	$(INST_MAN3DIR)/CfgTie::TiePh.$(MAN3EXT) \
	lib/CfgTie/filever.pm \
	$(INST_MAN3DIR)/CfgTie::filever.$(MAN3EXT) \
	lib/CfgTie/CfgArgs.pm \
	$(INST_MAN3DIR)/CfgTie::CfgArgs.$(MAN3EXT)

# --- MakeMaker processPL section:


# --- MakeMaker installbin section:

$(INST_SCRIPT)/.exists :: /usr/lib/perl5/i386-linux/5.00401/CORE/perl.h
	@$(MKPATH) $(INST_SCRIPT)
	@$(EQUALIZE_TIMESTAMP) /usr/lib/perl5/i386-linux/5.00401/CORE/perl.h $(INST_SCRIPT)/.exists

	-@$(CHMOD) 755 $(INST_SCRIPT)

EXE_FILES = bin/CfgAliases bin/CfgNamed bin/CfgAliases,v

all :: $(INST_SCRIPT)/CfgAliases $(INST_SCRIPT)/CfgAliases,v $(INST_SCRIPT)/CfgNamed

realclean ::
	rm -f $(INST_SCRIPT)/CfgAliases $(INST_SCRIPT)/CfgAliases,v $(INST_SCRIPT)/CfgNamed

$(INST_SCRIPT)/CfgAliases: bin/CfgAliases Makefile $(INST_SCRIPT)/.exists
	@rm -f $(INST_SCRIPT)/CfgAliases
	cp bin/CfgAliases $(INST_SCRIPT)/CfgAliases

$(INST_SCRIPT)/CfgAliases,v: bin/CfgAliases,v Makefile $(INST_SCRIPT)/.exists
	@rm -f $(INST_SCRIPT)/CfgAliases,v
	cp bin/CfgAliases,v $(INST_SCRIPT)/CfgAliases,v

$(INST_SCRIPT)/CfgNamed: bin/CfgNamed Makefile $(INST_SCRIPT)/.exists
	@rm -f $(INST_SCRIPT)/CfgNamed
	cp bin/CfgNamed $(INST_SCRIPT)/CfgNamed


# --- MakeMaker subdirs section:

# none

# --- MakeMaker clean section:

# Delete temporary files but do not touch installed files. We don't delete
# the Makefile here so a later make realclean still has a makefile to use.

clean ::
	-rm -rf *% *.html *~ www-* .htp* .htg* ./blib $(MAKE_APERL_FILE) $(INST_ARCHAUTODIR)/extralibs.all perlmain.c mon.out core so_locations pm_to_blib *~ */*~ */*/*~ *$(OBJ_EXT) *$(LIB_EXT) perl.exe $(BOOTSTRAP) $(BASEEXT).bso $(BASEEXT).def $(BASEEXT).exp
	-mv Makefile Makefile.old $(DEV_NULL)


# --- MakeMaker realclean section:

# Delete temporary files (via clean) and also delete installed files
realclean purge ::  clean
	rm -rf $(INST_AUTODIR) $(INST_ARCHAUTODIR)
	rm -f $(INST_LIB)/CfgTie/TieGroup.pm $(INST_LIB)/CfgTie/filever.pm,v $(INST_LIB)/CfgTie/Cfgfile.pm $(INST_LIB)/CfgTie/TieGroup.pm,v $(INST_LIB)/CfgTie/Cfgfile.pm,v $(INST_LIB)/CfgTie/makefile $(INST_LIB)/CfgTie/TieProto.pm $(INST_LIB)/CfgTie/TieProto.pm,v $(INST_LIB)/CfgTie/TiePh.pm $(INST_LIB)/CfgTie/TiePh.pm,v $(INST_LIB)/CfgTie/CfgArgs.pm $(INST_LIB)/CfgTie/CfgArgs.pm,v $(INST_LIB)/CfgTie/TieGeneric.pm $(INST_LIB)/CfgTie/TieHost.pm $(INST_LIB)/CfgTie/TieUser.pm $(INST_LIB)/CfgTie/TieGeneric.pm,v $(INST_LIB)/CfgTie/TieHost.pm,v $(INST_LIB)/CfgTie/TieServ.pm $(INST_LIB)/CfgTie/TieUser.pm,v $(INST_LIB)/CfgTie/TieAliases.pm $(INST_LIB)/CfgTie/TieServ.pm,v $(INST_LIB)/CfgTie/tmp $(INST_LIB)/CfgTie/TieAliases.pm,v $(INST_LIB)/CfgTie/TieNamed.pm $(INST_LIB)/CfgTie/TieRCService.pm $(INST_LIB)/CfgTie/TieShadow.pm $(INST_LIB)/CfgTie/TieNet.pm $(INST_LIB)/CfgTie/TieNamed.pm,v $(INST_LIB)/CfgTie/TieRCService.pm,v $(INST_LIB)/CfgTie/TieShadow.pm,v $(INST_LIB)/CfgTie/TieNet.pm,v $(INST_LIB)/CfgTie/filever.pm
	rm -rf Makefile Makefile.old


# --- MakeMaker dist_basics section:

distclean :: realclean distcheck

distcheck :
	$(PERL) -I$(PERL_ARCHLIB) -I$(PERL_LIB) -MExtUtils::Manifest=fullcheck \
		-e fullcheck

skipcheck :
	$(PERL) -I$(PERL_ARCHLIB) -I$(PERL_LIB) -MExtUtils::Manifest=skipcheck \
		-e skipcheck

manifest :
	$(PERL) -I$(PERL_ARCHLIB) -I$(PERL_LIB) -MExtUtils::Manifest=mkmanifest \
		-e mkmanifest


# --- MakeMaker dist_core section:

dist : $(DIST_DEFAULT)
	@$(PERL) -le 'print "Warning: Makefile possibly out of date with $$vf" if ' \
	    -e '-e ($$vf="$(VERSION_FROM)") and -M $$vf < -M "Makefile";'

tardist : $(DISTVNAME).tar$(SUFFIX)

zipdist : $(DISTVNAME).zip

$(DISTVNAME).tar$(SUFFIX) : distdir
	$(PREOP)
	$(TO_UNIX)
	$(TAR) $(TARFLAGS) $(DISTVNAME).tar $(DISTVNAME)
	$(RM_RF) $(DISTVNAME)
	$(COMPRESS) $(DISTVNAME).tar
	$(POSTOP)

$(DISTVNAME).zip : distdir
	$(PREOP)
	$(ZIP) $(ZIPFLAGS) $(DISTVNAME).zip $(DISTVNAME)
	$(RM_RF) $(DISTVNAME)
	$(POSTOP)

uutardist : $(DISTVNAME).tar$(SUFFIX)
	uuencode $(DISTVNAME).tar$(SUFFIX) \
		$(DISTVNAME).tar$(SUFFIX) > \
		$(DISTVNAME).tar$(SUFFIX)_uu

shdist : distdir
	$(PREOP)
	$(SHAR) $(DISTVNAME) > $(DISTVNAME).shar
	$(RM_RF) $(DISTVNAME)
	$(POSTOP)


# --- MakeMaker dist_dir section:

distdir :
	$(RM_RF) $(DISTVNAME)
	$(PERL) -I$(PERL_ARCHLIB) -I$(PERL_LIB) -MExtUtils::Manifest=manicopy,maniread \
		-e "manicopy(maniread(),'$(DISTVNAME)', '$(DIST_CP)');"


# --- MakeMaker dist_test section:

disttest : distdir
	cd $(DISTVNAME) && $(PERL) -I$(PERL_ARCHLIB) -I$(PERL_LIB) Makefile.PL
	cd $(DISTVNAME) && $(MAKE)
	cd $(DISTVNAME) && $(MAKE) test


# --- MakeMaker dist_ci section:

ci :
	$(PERL) -I$(PERL_ARCHLIB) -I$(PERL_LIB) -MExtUtils::Manifest=maniread \
		-e "@all = keys %{ maniread() };" \
		-e 'print("Executing $(CI) @all\n"); system("$(CI) @all");' \
		-e 'print("Executing $(RCS_LABEL) ...\n"); system("$(RCS_LABEL) @all");'


# --- MakeMaker install section:

install :: all pure_install doc_install

install_perl :: all pure_perl_install doc_perl_install

install_site :: all pure_site_install doc_site_install

install_ :: install_site
	@echo INSTALLDIRS not defined, defaulting to INSTALLDIRS=site

pure_install :: pure_$(INSTALLDIRS)_install

doc_install :: doc_$(INSTALLDIRS)_install
	@echo Appending installation info to $(INSTALLARCHLIB)/perllocal.pod

pure__install : pure_site_install
	@echo INSTALLDIRS not defined, defaulting to INSTALLDIRS=site

doc__install : doc_site_install
	@echo INSTALLDIRS not defined, defaulting to INSTALLDIRS=site

pure_perl_install ::
	@$(MOD_INSTALL) \
		read $(PERL_ARCHLIB)/auto/$(FULLEXT)/.packlist \
		write $(INSTALLARCHLIB)/auto/$(FULLEXT)/.packlist \
		$(INST_LIB) $(INSTALLPRIVLIB) \
		$(INST_ARCHLIB) $(INSTALLARCHLIB) \
		$(INST_BIN) $(INSTALLBIN) \
		$(INST_SCRIPT) $(INSTALLSCRIPT) \
		$(INST_MAN1DIR) $(INSTALLMAN1DIR) \
		$(INST_MAN3DIR) $(INSTALLMAN3DIR)
	@$(WARN_IF_OLD_PACKLIST) \
		$(SITEARCHEXP)/auto/$(FULLEXT)


pure_site_install ::
	@$(MOD_INSTALL) \
		read $(SITEARCHEXP)/auto/$(FULLEXT)/.packlist \
		write $(INSTALLSITEARCH)/auto/$(FULLEXT)/.packlist \
		$(INST_LIB) $(INSTALLSITELIB) \
		$(INST_ARCHLIB) $(INSTALLSITEARCH) \
		$(INST_BIN) $(INSTALLBIN) \
		$(INST_SCRIPT) $(INSTALLSCRIPT) \
		$(INST_MAN1DIR) $(INSTALLMAN1DIR) \
		$(INST_MAN3DIR) $(INSTALLMAN3DIR)
	@$(WARN_IF_OLD_PACKLIST) \
		$(PERL_ARCHLIB)/auto/$(FULLEXT)

doc_perl_install ::
	@$(DOC_INSTALL) \
		"Module" "$(NAME)" \
		"installed into" "$(INSTALLPRIVLIB)" \
		LINKTYPE "$(LINKTYPE)" \
		VERSION "$(VERSION)" \
		EXE_FILES "$(EXE_FILES)" \
		>> $(INSTALLARCHLIB)/perllocal.pod

doc_site_install ::
	@$(DOC_INSTALL) \
		"Module" "$(NAME)" \
		"installed into" "$(INSTALLSITELIB)" \
		LINKTYPE "$(LINKTYPE)" \
		VERSION "$(VERSION)" \
		EXE_FILES "$(EXE_FILES)" \
		>> $(INSTALLARCHLIB)/perllocal.pod


uninstall :: uninstall_from_$(INSTALLDIRS)dirs

uninstall_from_perldirs ::
	@$(UNINSTALL) $(PERL_ARCHLIB)/auto/$(FULLEXT)/.packlist

uninstall_from_sitedirs ::
	@$(UNINSTALL) $(SITEARCHEXP)/auto/$(FULLEXT)/.packlist


# --- MakeMaker force section:
# Phony target to force checking subdirectories.
FORCE:
	@$(NOOP)


# --- MakeMaker perldepend section:


# --- MakeMaker makefile section:

# We take a very conservative approach here, but it\'s worth it.
# We move Makefile to Makefile.old here to avoid gnu make looping.
Makefile : Makefile.PL $(CONFIGDEP)
	@echo "Makefile out-of-date with respect to $?"
	@echo "Cleaning current config before rebuilding Makefile..."
	-@$(MV) Makefile Makefile.old
	-$(MAKE) -f Makefile.old clean $(DEV_NULL) || $(NOOP)
	$(PERL) "-I$(PERL_ARCHLIB)" "-I$(PERL_LIB)" Makefile.PL 
	@echo "==> Your Makefile has been rebuilt. <=="
	@echo "==> Please rerun the make command.  <=="
	false

# To change behavior to :: would be nice, but would break Tk b9.02
# so you find such a warning below the dist target.
#Makefile :: $(VERSION_FROM)
#	@echo "Warning: Makefile possibly out of date with $(VERSION_FROM)"


# --- MakeMaker staticmake section:

# --- MakeMaker makeaperl section ---
MAP_TARGET    = perl
FULLPERL      = /usr/bin/perl

$(MAP_TARGET) :: static $(MAKE_APERL_FILE)
	$(MAKE) -f $(MAKE_APERL_FILE) $@

$(MAKE_APERL_FILE) : $(FIRST_MAKEFILE)
	@echo Writing \"$(MAKE_APERL_FILE)\" for this $(MAP_TARGET)
	@$(PERL) -I$(INST_ARCHLIB) -I$(INST_LIB) -I$(PERL_ARCHLIB) -I$(PERL_LIB) \
		Makefile.PL DIR= \
		MAKEFILE=$(MAKE_APERL_FILE) LINKTYPE=static \
		MAKEAPERL=1 NORECURS=1 CCCDLFLAGS=


# --- MakeMaker test section:

TEST_VERBOSE=0
TEST_TYPE=test_$(LINKTYPE)
TEST_FILE = test.pl
TESTDB_SW = -d

testdb :: testdb_$(LINKTYPE)

test :: $(TEST_TYPE)

test_dynamic :: pure_all
	PERL_DL_NONLAZY=1 $(FULLPERL) -I$(INST_ARCHLIB) -I$(INST_LIB) -I$(PERL_ARCHLIB) -I$(PERL_LIB) test.pl

testdb_dynamic :: pure_all
	PERL_DL_NONLAZY=1 $(FULLPERL) $(TESTDB_SW) -I$(INST_ARCHLIB) -I$(INST_LIB) -I$(PERL_ARCHLIB) -I$(PERL_LIB) $(TEST_FILE)

test_ : test_dynamic

test_static :: test_dynamic
testdb_static :: testdb_dynamic


# --- MakeMaker pm_to_blib section:

pm_to_blib: $(TO_INST_PM)
	@$(PERL) "-I$(INST_ARCHLIB)" "-I$(INST_LIB)" \
	"-I$(PERL_ARCHLIB)" "-I$(PERL_LIB)" -MExtUtils::Install \
        -e "pm_to_blib({qw{$(PM_TO_BLIB)}},'$(INST_LIB)/auto')"
	@$(TOUCH) $@


# --- MakeMaker selfdocument section:


# --- MakeMaker postamble section:

#This assumes, of course, that you have these tools installed...
CfgTie_toc.html: CfgTie.tex lib/CfgTie/TieRCService.pm lib/CfgTie/Cfgfile.pm lib/CfgTie/CfgArgs.pm lib/CfgTie/TieAliases.pm lib/CfgTie/TieGeneric.pm lib/CfgTie/TieGroup.pm lib/CfgTie/TieHost.pm lib/CfgTie/TieNamed.pm lib/CfgTie/TieNet.pm lib/CfgTie/TiePh.pm lib/CfgTie/TieProto.pm lib/CfgTie/TieServ.pm lib/CfgTie/TieShadow.pm lib/CfgTie/TieUser.pm Intro.tex
	make all -Clib/CfgTie
	make all -Cbin
	prj2texi MANIFEST > CodeMenu.tex
	texi2html -glossary -split_node -menu CfgTie.tex

texi: CfgTie_toc.html 
	../../tup.pl CfgTie

tarball: ../CfgTie-0.2
	 tar cv --gzip -C .. -f../CfgTie-0.2-`date +%Y%m%d`.tar.gz CfgTie-0.2 --exclude *,v --exclude blib -S



# End.
