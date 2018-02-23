# VersionParsing

[![Build Status](https://travis-ci.org/stevengj/VersionParsing.jl.svg?branch=master)](https://travis-ci.org/stevengj/VersionParsing.jl)

[![Coverage Status](https://coveralls.io/repos/stevengj/VersionParsing.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/stevengj/VersionParsing.jl?branch=master)

[![codecov.io](http://codecov.io/github/stevengj/VersionParsing.jl/coverage.svg?branch=master)](http://codecov.io/github/stevengj/VersionParsing.jl?branch=master)

The `VersionParsing` package implements flexible parsing of
version-number strings into Julia's built-in `VersionNumber` type, via
the `vparse(string)` function.

Unlike the `VersionNumber(string)` constructor, `vparse(string)` can
handle version-number strings in a much wider range of formats.
