using VersionParsing, Compat
using Compat.Test

@test vparse("3.7.2a4") == v"3.7.2-a4" == vparse("version 3.7.2a4: the best version")
@test vparse("2.1.0-python3_5") == v"2.1.0-python35" # Plots.jl#1432
@test vparse("0.99.1.1") == v"0.99.1+1" # julia#7282

# examples from npm docs (https://docs.npmjs.com/misc/semver)
@test_throws ArgumentError vparse("a.b.c")
@test vparse("  =v1.2.3   ") == v"1.2.3"
@test vparse("v2") == vparse("version 2.0") == v"2.0.0"
@test vparse("42.6.7.9.3-alpha") == v"42.6.7-alpha+9.3"

@test vparse("1.2.3.8-4.2") == v"1.2.3-4.2+8"
@test vparse("1.2.3.8-4..b2+9.7++2-0") == v"1.2.3-4.b2+8.9.7.2-0"

# Debian-style epoch:upstream version numbers
@test vparse("4:4.7.4-0ubuntu8") == vparse("0:4.7.4-0ubuntu8") == v"4.7.4-0ubuntu8"

@test vparse(".3") == v"0.3.0"
