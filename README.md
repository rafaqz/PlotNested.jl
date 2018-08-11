# PlotNested

[![Build Status](https://travis-ci.org/rafaqz/PlotNested.jl.svg?branch=master)](https://travis-ci.org/rafaqz/PlotNested.jl)
[![Coverage Status](https://coveralls.io/repos/rafaqz/PlotNested.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/rafaqz/PlotNested.jl?branch=master)
[![codecov.io](http://codecov.io/github/rafaqz/PlotNested.jl/coverage.svg?branch=master)](http://codecov.io/github/rafaqz/PlotNested.jl?branch=master)

This package retrieves and plots all the arrays in any nested data type, and provides
checkboxes to select which arrays to plot interactively, using Interact.jl.

```julia
using Plots

struct TestData{T}
    n::Symbol
    x::Int
    a::Vector
    t::T
end

julia> testdata = TestData(:child, 2, [4,5,6], [7 8; 9 10])                          
TestData{Array{Int64,2}}(:child, 2, [4, 5, 6], [7 8; 9 10])                          

julia> plotnames(testdata)
(:a, :t)

julia> plotdata(testdata)
([4, 5, 6], [7 8; 9 10])

julia> plot_selected(testdata, true, false, true)                                    
1-element Array{Plots.Plot{Plots.GRBackend},1}:                                      
 Plot{Plots.GRBackend() n=1}

julia> plot_all(testdata)
2-element Array{Plots.Plot{Plots.GRBackend},1}:                                      
 Plot{Plots.GRBackend() n=1}
 Plot{Plots.GRBackend() n=2}

julia> autoplot(testdata)

julia> plotchecks(testdata)
2-element Array{Widgets.Widget{:checkbox},1}:
 Widgets.Widget{:checkbox}(DataStructures.OrderedDict{Symbol,Any}(:changes=>Observables.Observable{Int64}("ob_50",
 ...
```

