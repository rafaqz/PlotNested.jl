using PlotNested, Plots

@static if VERSION < v"0.7.0-DEV.2005"
    using Base.Test
else
    using Test
end

struct TestData{T}
    n::Symbol
    x::Int
    a::Vector
    t::T
end

gr()
testdata = TestData(:parent, 1, [1,2,3], TestData(:child, 2, [4,5,6], [7 8; 9 10]))
@test plottables(testdata) == (:a => [1,2,3], :a => [4,5,6], :t => [7 8; 9 10])  
@test plotnames(testdata) == (:a, :a, :t)  
@test plotdata(testdata) == ([1,2,3], [4,5,6], [7 8; 9 10])  
@test length(plot_selected(testdata, true, false, true)) == 2
@test typeof(plot_selected(testdata, true, false, true)) == Array{Plots.Plot{Plots.GRBackend},1}
@test length(plot_all(testdata)) == 3
@test typeof(plot_all(testdata)) == Array{Plots.Plot{Plots.GRBackend},1}
@test typeof(plotchecks(testdata)) == Array{Widgets.Widget{:checkbox},1}
@test length(plotchecks(testdata)) == 3

# autoplot(testdata)
