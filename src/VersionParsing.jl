"""
The `VersionParsing` package implements flexible parsing of
version-number strings into Julia's built-in `VersionNumber` type, via
the `vparse(string)` function.

Unlike the `VersionNumber(string)` constructor, `vparse(string)` can
handle version-number strings in a much wider range of formats
without throwing an exception.
"""
module VersionParsing
using Compat
export vparse

"""
    vparse(s::AbstractString)

Returns a `VersionNumber` representing as much as possible of the version
information in the string `s`.

Typically, `s` is a string of the form `"major[.minor.patch]"`, but several
variations on this format are supported, including:

* `major.minor.patch[.+-]something[.+-]something` is converted if possible into the
  closest `VersionNumber` equivalent (`something` becomes a prerelease
  or build identifier).
* Non-numeric prefixes are stripped along with any invalid version characters.
* Text following whitespace after the version number is ignored.
* In Debian-style version numbers `epoch:major.minor.patch-rev`, the "epoch"
  is ignored and only the upstream version `major.minor.patch-rev` is used.
* When all else fails, everything except the first `major.minor.patch`
  digits found are ignored.
"""
vparse(s::AbstractString) = vparse(String(s))

digits2num(s::AbstractString) = all(isdigit, s) ? parse(Int, s) : s
splitparts(s::AbstractString) = map(digits2num, filter!(!isempty, split(s, '.')))

function vparse(s_::String)
    s = replace(s_, r"^\D+"=>"") # strip non-numeric prefix
    isempty(s) && throw(ArgumentError("non-numeric version string $s_"))
    if ismatch(r"^\d:\d+", s) # debian-style version number
        s = replace(s, r"^\d:"=>"") # strip epoch
    end
    i = Compat.findfirst(isspace, s)
    if i !== nothing
        s = s[1:prevind(s,i)]
    end
    s = replace(s, r"[^A-Za-z0-9.+-]*"=>"") # strip invalid version chars
    try
        return VersionNumber(s) # first look for semver-compliant version
    catch
        m = match(r"^(\d+)(\.\d+)?(\.\d+)?", s)
        m === nothing && throw(ArgumentError("unrecognized version string $s_"))
        major = parse(Int, m[1])
        minor = m[2] === nothing ? 0 : parse(Int, m[2][2:end])
        patch = m[3] === nothing ? 0 : parse(Int, m[3][2:end])
        pre = build = ()
        s = s[m.match.endof+1:end] # remaining string after the match
        @assert !isempty(s) # otherwise VersionNumber(s) would have succeeded
        if ismatch(r"^\.\d", s) # treat following x.y.z digits as build part
            m = match(r"^(\.\d)+", s)
            build = (build..., splitparts(m.match)...)
            s = s[m.match.endof+1:end]
        end
        splitplus = split(s, '+')
        if !isempty(splitplus[1])
            pre = (pre..., splitparts(splitplus[1][1]=='-' ? splitplus[1][2:end] : splitplus[1])...)
        end
        for j = 2:length(splitplus) # build version(s)
            build = (build..., splitparts(splitplus[j])...)
        end
        return VersionNumber(major, minor, patch, pre, build)
    end
end

end # module
