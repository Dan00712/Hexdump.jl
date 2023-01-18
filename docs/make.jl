using Documenter
using Hexdump

makedocs(
    sitename = "Hexdump",
    format = Documenter.HTML(),
    modules = [Hexdump]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "https://github.com/Dan00712/Hexdump.jl",
    target = "build",
    branch = "gh-pages"
)=#
