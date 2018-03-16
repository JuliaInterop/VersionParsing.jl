# VersionParsing

[![Build Status](https://travis-ci.org/stevengj/VersionParsing.jl.svg?branch=master)](https://travis-ci.org/stevengj/VersionParsing.jl)
[![Build status](https://ci.appveyor.com/api/projects/status/ae5feyhjn609p7ec?svg=true)](https://ci.appveyor.com/project/StevenGJohnson/versionparsing-jl)
[![Coverage Status](https://coveralls.io/repos/stevengj/VersionParsing.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/stevengj/VersionParsing.jl?branch=master)
[![codecov.io](http://codecov.io/github/stevengj/VersionParsing.jl/coverage.svg?branch=master)](http://codecov.io/github/stevengj/VersionParsing.jl?branch=master)

The `VersionParsing` package implements flexible parsing of
version-number strings into Julia's built-in `VersionNumber` type, via
the `vparse(string)` function.

Unlike the `VersionNumber(string)` constructor, `vparse(string)` can
handle version-number strings in a much wider range of formats.  For example,

* `major.minor.patch[.+-]something[.+-]something` is converted if possible into the
  closest `VersionNumber` equivalent (`something` becomes a prerelease
  or build identifier).
* Non-numeric prefixes are stripped along with any invalid version characters.
* Text following whitespace after the version number is ignored.
* When all else fails, everything except the first `major.minor.patch`
  digits found are ignored.
