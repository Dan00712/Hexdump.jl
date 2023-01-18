# Hexdump

![GH-Pages](https://github.com/Dan00712/Hexdump.jl/actions/workflows/documentation.yml/badge.svg)

A package in julia that allows the user to inspect the hexdump output of a stream/file.  

# Installation

In order to install this package run
```julia
using Pkg
Pkg.add("https://github.com/Dan00712/Hexdump.jl")
```
# Usage

The package exposes a ´hexdump´ function.

```julia
using Hexdump

hexdump("<path to file>")
```

This function call prints the contents of the file to `stdout`  
For a more specific documentation see the [Documentation](https://dan00712.github.io/Hexdump.jl/)