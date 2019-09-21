module MyTools

using InteractiveUtils

function subtypes(t::DataType; recurse::Bool = false)
    #println("MyTools.subtypes: recurse = ", recurse)
    stypes = InteractiveUtils.subtypes(t)
    isempty(stypes) && return stypes
    if recurse
        for stype in stypes
            #println("stype = ", stype)
            if isa(stype, DataType)
                append!(stypes, subtypes(stype, recurse = true))
            end
        end
    end
    return stypes
end

function discover_interface(t::DataType)
    stypes = MyTools.subtypes(t, recurse=true)
    countmap = Dict{String,Int}()
    for stype in stypes
        stypemethods = methodswith(stype)
        for m in stypemethods
            mname = String(m.name)
            countmap[mname] = get(countmap, mname, 0) + 1
        end
    end

    return sort(collect(countmap), by = x->last(x), rev=true)
end



end # module
