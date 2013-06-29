# expandr - For people who like real urls.

expandr is a tiny web service that expands shortened urls into their
actual form. It's for people who like to see where the links they click
on go.

## Quickstart

It's written in Haskell, so you need the Haskell Platform installed.
Additionally you need the `scotty` and `aeson` packages. I'll try to
cabalize this package soon so watch out for that.

## ToDo

* cabalization
* testing (functional, performance)
* deploy this somewhere

* maybe invalidate cached urls (e.g. check the response code, store the
  cached url accordingly and invalidate if needed)
* more shorteners
* browser extension (which is actually why I've written this thing)
