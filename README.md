Rmath.jl
========

Archive of functions that emulate R's d-p-q-r functions for probability distributions.

This package will download and compile [libRmath-julia](https://github.com/JuliaLang/Rmath-julia/blob/master/COPYING)
on Julia 0.5 and newer where it is no longer built as part of Julia. Note that
libRmath-julia is licensed under the GPLv2, see https://github.com/JuliaLang/Rmath-julia/blob/master/COPYING.
The Julia bindings here are licensed under [MIT](LICENSE.md).

If you only want to use this package for the sake of building the Rmath library, you can do
```julia
Pkg.add("Rmath")
Pkg.build("Rmath")
import Rmath: libRmath
libRmath
```
