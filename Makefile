extractPath:
	ocamlfind ocamlopt -package xmlm xmlm.cmxa extractPath.ml -o extractPath

install:extractPath
	cp $< ${PREFIX}/bin/

uninstall:
	rm ${PREFIX}/bin/extractPath

include Makefile.prefix

clean:
	rm -f *~ *.cmxa *.cm[ioxa]
