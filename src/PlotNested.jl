module PlotNested

using Requires, 
      Interact, 
      Observables, 
      Plots 

export @plottable, plottable, plottables, plotnames, plotdata, plotchecks, plot_selected, plot_all, autoplot

nested(T::Type, P::Type, expr_builder) = 
    expr_combiner(T, [Expr(:..., expr_builder(T, fn)) for fn in fieldnames(T)])

expr_combiner(T, expressions) = Expr(:tuple, expressions...)


##### Flattening
plottables_expr(T, index) = :(plottables(getfield(t, $(QuoteNode(index))), P, $(QuoteNode(index))))
plottables_inner(T, P) = nested(T, P, plottables_expr)
 
plottables(x) = plottables(x, Nothing, :unnamed)
plottables(x::AbstractArray, P, fname) = (fname => x,)
@generated plottables(t, P, fname) = plottables_inner(t, P)



##### Plot generation 
plotnames(x) = getfield.(plottables(x), 1)

plotdata(x) = getfield.(plottables(x), 2)
plotdata(x, range) = [d[range.start:min(range.stop, length(d))] for d in plotdata(x)]

plotchecks(x) = [checkbox(false, label=name) for name in plotnames(x)]

plot_selected(x, checklist, args...) = begin
    d = plotdata(x, args...)
    [plot(d[i]) for (i, check) in enumerate(checklist) if check] 
end
plot_all(x) = [plot(data) for (i, (name, data)) in enumerate(plottables(x))] 

autoplot(x) = plot(plot_all(x)...)


function __init__()
    @require DataFrames="a93c6f00-e57d-5684-b7b6-d8193f3e46c0" begin
        plottables(x::DataFrames.DataFrame, P, fname) = (fname => x,)
    end
    @require TypedTables="9d95f2ec-7b3d-5a63-8d20-e2491e220bb9" begin
        plottables(x::TypedTables.Table, P, fname) = (fname => x,)
    end
end

end # module
