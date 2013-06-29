SOURCES=$(shell find . -type f -name '*.hs')

expandr: ${SOURCES}
	ghc Main.hs -o expandr

run: expandr
	./expandr

clean:
	rm -f *.{o,hi} Expandr/*.{o,hi} expandr
