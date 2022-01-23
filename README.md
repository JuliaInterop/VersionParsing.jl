# VersionParsing

[![Build Status](https://travis-ci.org/JuliaInterop/VersionParsing.jl.svg?branch=master)](https://travis-ci.org/JuliaInterop/VersionParsing.jl)
[![Build status](https://ci.appveyor.com/api/projects/status/xkaf2sictojyii01?svg=true)](https://ci.appveyor.com/project/StevenGJohnson/versionparsing-jl-r0aae)
[![codecov.io](http://codecov.io/github/JuliaInterop/VersionParsing.jl/coverage.svg?branch=master)](http://codecov.io/github/JuliaInterop/VersionParsing.jl?branch=master)

The `VersionParsing` package implements flexible parsing of
version-number strings into Julia's built-in `VersionNumber` type, via
the `vparse(string)` function.

Unlike the `VersionNumber(string)` constructor, `vparse(string)` can
handle version-number strings in a much wider range of formats than
are encompassed by the [semver standard](https://semver.org/).  This
is useful in order to support `VersionNumber` comparisons applied
to "foreign" version numbers from external packages.

For example,

* Non-numeric prefixes are stripped along with any invalid version characters.
  Commas are treated as decimal points, and underscores are treated as hyphens.
* Text following whitespace or other invalid-version characters after the version number is ignored.
* `major.minor.patch.x.y.z` is supported, with `x.y.z` prepended to the
  semver build identifier, i.e. it is parsed like `major.minor.patch+x.y.z`.
* Multiple `+x+y` build identifiers are concatenated as if they were `+x.y`.
* A leading `0` is prepended if needed, e.g. `.x` is treated as `0.x`.
* When all else fails, everything except the first `major.minor.patch`
  digits found are ignored.
