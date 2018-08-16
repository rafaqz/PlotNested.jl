__precompile__()

module PlotNested

using Nested, Requires, Observables, InteractBase, Plots 

export @plottable, plottable, plottables, plotnames, plotdata, plotchecks, plot_selected, plot_all, autoplot

# Flattening

plottables_expr(T, path, index) = :(plottables(getfield($path, $(QuoteNode(index))), P, $(QuoteNode(index))))
plottables_inner(T) = nested(T, :t, plottables_expr)
 
plottables(x) = plottables(x, Void, :unnamed)
plottables(x::AbstractArray, P, fname) = (fname => x,)
@require DataFrames begin
    plottables(x::DataFrames.DataFrame, P, fname) = (fname => x,)
end
@require TypedTables begin
    plottables(x::TypedTables.Table, P, fname) = (fname => x,)
end
@generated plottables(t, P, fname) = plottables_inner(t)


# Plot generation 

plotnames(x) = getfield.(plottables(x), 1)
plotdata(x, range) = [d[range.start:min(range.stop, length(d))] for d in getfield.(plottables(x), 2)]
plotchecks(x) = [checkbox(false, label=name) for name in plotnames(x)]

plot_selected(x, checklist, range) = begin
    d = plotdata(x, range)
    [plot(d[i]) for (i, check) in enumerate(checklist) if check] 
end
plot_all(x) = [plot(data) for (i, (name, data)) in enumerate(plottables(x))] 

autoplot(x) = plot(plot_all(x)...)

end # module
