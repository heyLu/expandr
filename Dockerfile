FROM darinmorrison/haskell

EXPOSE 3000

RUN cabal update

RUN cabal install --bindir=/usr/bin

CMD ["expandr"]
