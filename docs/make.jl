using HashFunctions
using Documenter

makedocs(;
    modules=[HashFunctions],
    authors="Robert Feldt",
    repo="https://github.com/robertfeldt/HashFunctions.jl/blob/{commit}{path}#L{line}",
    sitename="HashFunctions.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://robertfeldt.github.io/HashFunctions.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/robertfeldt/HashFunctions.jl",
)
