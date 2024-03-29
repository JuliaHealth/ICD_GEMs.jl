using ICD_GEMs
using Documenter

DocMeta.setdocmeta!(ICD_GEMs, :DocTestSetup, :(using ICD_GEMs); recursive=true)

makedocs(;
    modules=[ICD_GEMs],
    authors="Pietro Monticone, Claudio Moroni",
    repo="https://github.com/JuliaHealth/ICD_GEMs.jl/blob/{commit}{path}#{line}",
    sitename="ICD_GEMs.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://juliahealth.org/ICD_GEMs.jl",
        assets=String[],
    ),
    pages=[
        "Home"      => "index.md",
        "API" => "API.md"
    ],
)

deploydocs(;
    repo="github.com/JuliaHealth/ICD_GEMs.jl",
    devbranch="main",
    push_preview = true
)
