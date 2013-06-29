expandr:
	ghc Main.hs -o expandr

run: expandr
	./expandr

clean:
	rm -f *.{o,hi} Expandr/*.{o,hi} expandr
