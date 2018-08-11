__precompile__()

module PlotNested

using Nested, Observables, InteractBase, Plots 

export @plottable, plottable, plottables, plotnames, plotdata, plotchecks, plot_selected, plot_all, autoplot

plottables_expr(T, path, index) = :(plottables(getfield($path, $(QuoteNode(index))), P, $(QuoteNode(index))))
plottables_inner(T) = nested(T, :t, plottables_expr)
 
plottables(x) = plottables(x, Void, :unnamed)
plottables(x::AbstractArray, P, fname) = (fname => x,)
@generated plottables(t, P, fname) = plottables_inner(t)

plotnames(x) = getfield.(plottables(x), 1)
plotdata(x) = getfield.(plottables(x), 2)
plotchecks(x) = [checkbox(false, label=name) for name in plotnames(x)]

plot_selected(x, checklist...) = begin
    ps = plotdata(x)
    [plot(ps[i]) for (i, check) in enumerate(checklist) if check] 
end
plot_all(x) = [plot(data) for (i, (name, data)) in enumerate(plottables(x))] 

autoplot(x) = plot(plot_all(x)...)

end # module
