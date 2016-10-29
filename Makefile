PEFCHAIN=./spindle/pefchain
PEFFLAGS=-ww

all:		prutswerk.d64

.PHONY:		prutswerk.d64 *.dir

%.dir:
		make -C $(basename $@)

prutswerk.d64:	script dirart.txt title.dir ecmplasma.dir raster.dir music.dir
		${PEFCHAIN} ${PEFFLAGS} -o $@ -a dirart.txt -d 2 $<
