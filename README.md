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

It's written in Haskell, so you need the Haskell Platform installed.
Additionally you need the `scotty` and `aeson` packages. I'll try to
cabalize this package soon so watch out for that.

## ToDo

* testing (functional, performance)
* deploy this somewhere

* maybe invalidate cached urls (e.g. check the response code, store the
  cached url accordingly and invalidate if needed)
* more shorteners
* browser extension (which is actually why I've written this thing)
