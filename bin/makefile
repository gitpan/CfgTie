include ../makefile.inc

install:

all: CfgAliases.txh CfgNamed.txh mail-validate.txh

mail-validate.txh: mail-validate 
	pod2txh $* 

CfgAliases.txh: CfgAliases
	pod2txh CfgAliases

CfgNamed.txh: CfgNamed
	pod2txh CfgNamed
