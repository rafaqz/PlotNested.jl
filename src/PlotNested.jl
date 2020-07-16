module PlotNested

using Requires,
      FieldMetadata,
      Interact,
      Plots

import FieldMetadata: @plottable, plottable

export @plottable, plottable, plottables, plotnames, plotdata, plotchecks, plot_selected, plot_all, autoplot



function __init__()
    @require DataFrames="a93c6f00-e57d-5684-b7b6-d8193f3e46c0" begin
        plottables(x::DataFrames.DataFrame, fname) = (fname => x,)
    end
    @require TypedTables="9d95f2ec-7b3d-5a63-8d20-e2491e220bb9" begin
        plottables(x::TypedTables.Table, fname) = (fname => x,)
    end
end


##### Flattening

plottables_expr(T, index) = quote
    if plottable($T, Val{$(QuoteNode(index))})
        plottables(getfield(t, $(QuoteNode(index))), $(QuoteNode(index)))
    else
        ()
    end
end

plottables_expr(T::Type{X}, index) where X <: Tuple = quote
    plottables(getfield(t, $(QuoteNode(index))), Symbol(fname, $(QuoteNode(index))))
end

wrap(expressions) = Expr(:tuple, Expr.(:..., expressions)...)

plottables(x) = plottables(x, :unnamed)
plottables(x::AbstractArray, fname) = (fname => x,)
plottables(x::Tuple{N,AbstractArray}, fname) where N = (fname => x,)
plottables(x::Tuple{}, fname) where N = ()
@generated plottables(t::T, fname) where T =
    wrap([plottables_expr(T, fn) for fn in fieldnames(T)])

##### Plot generation 
plotnames(x) = getfield.(plottables(x), 1)

plotdata(x) = getfield.(plottables(x), 2)
plotdata(x, range) = [getrange(d, range) for d in plotdata(x)]
getrange(d::AbstractVector, range) = begin
    d[first(range):min(last(range), length(d))]
end
getrange(d::AbstractMatrix, range) = d[first(range):min(last(range), length(d)), :]
getrange(d::AbstractArray{T,3}, range) where T = d[:, :, first(range):min(last(range), length(d))]

plotchecks(x) = [checkbox(false, label=string(name)) for name in plotnames(x)]

plot_selected(x, checklist, args...) = begin
    labels = map(string, plotnames(x))
    d = plotdata(x, args...)
    [plot(d[i], label=labels[i]) for (i, check) in enumerate(checklist) if check] 
end
plot_all(x) = [plot(data) for (i, (name, data)) in enumerate(plottables(x))] 

autoplot(x) = plot(plot_all(x)...)



end # module
