CFLAGS=-Wall
MKPEF=../spindle/mkpef
PEF2PRG=../spindle/pef2prg

all:			title.pef title.prg

effect.efo:		effect.s
			xa -O PETSCREEN -o $@ $<

title.pef:		effect.efo # Add more files here...
			${MKPEF} -o $@ $^

%.prg:			%.pef
			${PEF2PRG} -o $@ $^
