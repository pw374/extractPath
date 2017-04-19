BINS := extractPath scalePath

all: ${BINS}

extractPath:
	ocamlfind ocamlopt -package xmlm xmlm.cmxa $< -o $@

scalePath:extractNumbers.ml scalePath.ml
	ocamlfind ocamlopt $^ -o $@

install: ${BINS}
	cp $^ ${PREFIX}/bin/

uninstall:
	rm -f ${PREFIX}/bin/extractPath
	rm -f ${PREFIX}/bin/scalePath

include Makefile.prefix

clean:
	rm -f *~ *.cmxa *.cm[ioxa]
