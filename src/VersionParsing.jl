__precompile__(true)

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
information in the string `s`.  A much wider range of formats is supported
than the semver styles recognized by `VersionNumber(s)`.

For example,

* Non-numeric prefixes are stripped along with any invalid version characters.
  Commas are treated as decimal points.
* Text following whitespace after the version number is ignored.
* `major.minor.patch.x.y.z` is supported, with `x.y.z` prepended to the
  semver build identifier, i.e. it is parsed like `major.minor.patch+x.y.z`.
* Multiple `+x+y` build identifiers are concatenated as if they were `+x.y`.
* A leading `0` is prepended if needed, e.g. `.x` is treated as `0.x`.
* When all else fails, everything except the first `major.minor.patch`
  digits found are ignored.
"""
vparse(s::AbstractString) = vparse(String(s))

digits2num(s::AbstractString) = all(isdigit, s) ? parse(Int, s) : s
splitparts(s::AbstractString) = map(digits2num, filter!(!isempty, split(s, '.')))

function vparse(s_::String)
    s = replace(s_, ','=>".") # treat , as . (e.g MS resource-file syntax)
    s = replace(s, r"^[^0-9.]+"=>"") # strip non-numeric prefix
    isempty(s) && throw(ArgumentError("non-numeric version string $s_"))
    contains(s, r"^\.\d") && (s = "0" * s) # treat .x as 0.x
    if contains(s, r"^\d:\d+") # debian-style version number
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
        s = s[m.offset + lastindex(m.match):end] # remaining string after the match
        @assert !isempty(s) # otherwise VersionNumber(s) would have succeeded
        if s[1] == '.' # treat following x.y.z as build part
            m = match(r"^(\.[0-9a-zA-Z]*)+", s)
            build = (build..., splitparts(m.match)...)
            s = s[m.offset + lastindex(m.match):end]
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
