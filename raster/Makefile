CFLAGS=-Wall
MKPEF=../spindle/mkpef
PEF2PRG=../spindle/pef2prg


all:			raster.pef raster.prg


effect.efo:		effect.s
			xa -o $@ $<

raster.pef:		effect.efo # Add more files here...
			${MKPEF} -o $@ $^

%.prg:			%.pef
			${PEF2PRG} -o $@ $^
