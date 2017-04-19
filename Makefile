BINS := extractPath scalePath

all: ${BINS}

extractPath:
	ocamlfind ocamlopt -package xmlm xmlm.cmxa extractPath.ml -o extractPath

scalePath:
	ocamlfind ocamlopt extractNumbers.ml scalePath.ml -o scalePath

install: ${BINS}
	cp $^ ${PREFIX}/bin/

uninstall:
	rm -f ${PREFIX}/bin/extractPath
	rm -f ${PREFIX}/bin/scalePath

include Makefile.prefix

clean:
	rm -f *~ *.cmxa *.cm[ioxa]
