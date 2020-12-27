# -*- Mode: julia -*-
#
# Packages to check:
# - Revise
#
# Other ideas:
# - https://discourse.julialang.org/t/what-is-in-your-startup-jl/18228

print("Starting startup.jl")

import Pkg
let
    pkgs = ["OhMyREPL"]
    for pkg in pkgs
        if Base.find_package(pkg) === nothing
            Pkg.add(pkg)
        end
    end
end

using OhMyREPL

print("Startup complete")
