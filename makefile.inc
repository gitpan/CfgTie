.SUFFIXES: .c .s .asm .a .o .exe .dxe .svf .xsv .tex .txh .txt .html .bin .inf .pl .p .pm .cgi .prj
DEFAULT: install all

DEBUG = -DDEBUG -g
PROFILE = -pg
STD_DEFINES = -O3 $(DEBUG) $(PROFILE) -Wall -fvolatile-global -Wmissing-declarations
STD_CPP_DEFINES = 

GCCFLAGS = -DNO_ASM -fstrength-reduce -Wall
CC = gcc
#LOC=c:\Local
#Loc=c:/local
Loc=/usr/local
LOC=$(Loc)
CCLOCAL=$(LOC)
CCLoc=$(Loc)
CFLAGS = $(INCLUDES) $(DEFINES) $(STD_DEFINES) $(GCCFLAGS) $(QCCFLAGS) $(CLFLAGS)

INCLUDES = -I$(CCLOCAL)\include -I$(LOC)\include
LOCLIB= $(CCLOCAL)\lib
LocLib= $(CCLoc)/lib
LocInc= $(CCLoc)/include
LocBin = $(CCLoc)/bin

AR = ar clq
AS = as
CPP = cpp $(STD_CPP_DEFINES)
RM = del
RL = ranlib

# If you have DJGPP, you can use copy-smart, otherwise use copy
#CP = copy-smart
#CPy = copy
CP=cp -b -u
#CP = copy
#CP = cp

MAKE=make LIBNAME=$(LIBNAME)
#TEXISPLIT=--no-split
#TEXISPLIT=-split_chapter
TEXISPLIT=-split_node

# Extension Translation
.o.exe:
	$(CC) $*.o $(CFLAGS) -o $*

.c.o: $*.txh
	$(CC) -c $(CFLAGS) $*.c

.s.o:
	$(CC) $(CFLAGS) -c $<

.o.dxe:
	dxegen $*.dxe $*.o $(DXE_Objs) $(DXE_Libs)

.tex.inf:
	makeinfo --no-split $*.tex

.tex.html:
	texi2html -glossary $(TEXISPLIT) -menu $*.tex

.asm.txh:
	c2txh <$*.asm >$*.txh

.asm.com:
	asm16 $*.asm $*.com

.asm.bin:
	djasm $*.asm $*.bin

.c.txh:
	c2txh <$*.c >$*.txh

.pl.tex:
	pod2texinfo $*.pl

.pm.tex:
	pod2texinfo $*.pm

.p.tex:
	pod2texinfo $*.p

.prj.tex:
	prj2texi.pm $*.prj >$*.tex

.xsv.txt:
	xsvf2ascii $*.xsv $*.txt

.svf.xsv:
	svf2xsvf $*.svf $*.xsv

clean:
	$(RM) *.o
	$(RM) *.a
	$(RM) *.exe
	$(RM) *.txh

$(LIBNAME).a:	$(OBJS)  
	$(AR) $(TMP)/$@ $(OBJS)
	$(RL) $(TMP)/$@
	$(CPy) $(TMP)\$@ $(LOCLIB)

