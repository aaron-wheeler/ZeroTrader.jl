using ZeroTrader
using Documenter

DocMeta.setdocmeta!(ZeroTrader, :DocTestSetup, :(using ZeroTrader); recursive=true)

makedocs(;
    modules=[ZeroTrader],
    authors="aaron-wheeler",
    repo="https://github.com/aaron-wheeler/ZeroTrader.jl/blob/{commit}{path}#{line}",
    sitename="ZeroTrader.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://aaron-wheeler.github.io/ZeroTrader.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/aaron-wheeler/ZeroTrader.jl",
    devbranch="main",
)
