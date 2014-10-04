FROM darinmorrison/haskell

EXPOSE 3000

RUN apt-get install zlib1g-dev

RUN cabal update

ADD . /usr/src/expandr

RUN cd /usr/src/expandr && cabal install --bindir=/usr/bin

CMD ["expandr"]
