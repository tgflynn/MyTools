module MyTools

using InteractiveUtils

export where

function all_loaded_modules()
	modules = []
	for mod in Base.loaded_modules_array()
		for name in names(mod, all=true)
			#println("name = ", name)
			if ! isdefined(mod, name)
				continue
			end
			obj = getfield(mod, name)
			if isa(obj, Module)
				push!(modules, obj)
			end
		end
	end
	return modules
end

"""
Returns an array of all loaded modules in which the symbol x is defined. 
"""
function where(x::Symbol)
	modules = []
 	for mod in all_loaded_modules()
		if isdefined(mod, x)
			push!(modules, mod)
		end
	end
	return modules
end

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
    return unique(stypes)
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
