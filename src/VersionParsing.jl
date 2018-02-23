"""
The `VersionParsing` package implements flexible parsing of
version-number strings into Julia's built-in `VersionNumber` type, via
the `vparse(string)` function.

Unlike the `VersionNumber(string)` constructor, `vparse(string)` can
handle version-number strings in a much wider range of formats.
"""
module VersionParsing
export vparse

"""
    vparse(s::AbstractString)

Returns a `VersionNumber` representing the version information in the
string `s`.

Typically, `s` is a string of the form `"major.minor.patch"`, but many
variations on this format are supported, including:

* `"major.minor.patch[.+-]something[.+-]something"` is supported, converted into the
  closest `VersionNumber` equivalent (`something` becomes a prerelease
  or build identifier).
* `"version"` or `"v"` prefixes (of any case) are stripped.
* All whitespace is ignored.
"""
vparse(s::AbstractString) = vparse(String(s))

function vparse(s::String)
    s = replace(s, isspace=>"") # rm whitespace
    s = replace(s, r"^(version|vers|v)"i=>"") # strip prefix
    try
        return VersionNumber(s)
    catch
    end
end

end # module
