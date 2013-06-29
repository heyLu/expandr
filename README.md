# expandr - For people who like real urls.

expandr is a tiny web service that expands shortened urls into their
actual form. It's for people who like to see where the links they click
on go.

**Important:** This project is not yet ready for world domination. If
you'd like to use a real version of this thing, use [one](http://longurl.com)
[of](http://urlex.org/) [the](http://checkshorturl.com/)
[existing](http://www.wheredoesthislinkgo.com/)
[ones](http://expandurl.appspot.com/).

## Quickstart

    # You need the Haskell Platform for this
    $ cabal build
    $ ./dist/build/expandr/expandr
    # Visit 0.0.0.0:3000/help

Alternatively, if you're developing this thing, the following might be
faster:

    # 1. Install the necessary dependencies
    $ cabal install --only-dependencies
    # 2. Build and run
    $ make
    $ ./expandr
    # 3. Improve it, go to 2.
    # 4. Use ghci/vim-hdevtools/whatever-makes-you-happy

## ToDo

* testing (functional, performance)
* deploy this somewhere

* maybe invalidate cached urls (e.g. check the response code, store the
  cached url accordingly and invalidate if needed)
* more shorteners
* browser extension (which is actually why I've written this thing)
