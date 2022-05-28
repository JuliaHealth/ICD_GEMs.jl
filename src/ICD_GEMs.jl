###########################
####### ICD_GEMs.jl #######
###########################

######## PACKAGE NAME #########
module ICD_GEMs

###### EXPORTED OBJECTS ######
export get_GEM_dataframe_from_cdc_gem_txt, get_GEM_dict_from_GEM_dataframe, get_GEM_dictionary_from_cdc_gem_txt,
    GEM,
    get_oom, get_ICD_code_range, execute_applied_mapping,
    GEM_I10_I9_dataframe, GEM_I10_I9_dictionary, GEM_I9_I10_dataframe, GEM_I9_I10_dictionary

####### DEPENDENCIES ########
using DataFrames, DataStructures

########## CODES ###########
include("codes.jl")

######### STRUCTS #########
"""
    AbstractGEM{T}

An abstract type representing a **General Equivalence Map (GEM)**. `T` is the type of the low-level data structure used to represent the GEM.
"""
abstract type AbstractGEM{T} end

"""
    struct GEM{T <: Union{DataFrame, OrderedDict{String, OrderedDict{String, Any}}}}

Represents a **General Equivalence Map (GEM)** table.

# FIELDS
- `data<: Union{DataFrame,OrderedDict{String, OrderedDict{String, Any}}}`: the actual GEM data, as returned by `get_gem_dataframe_from_cdc_gem_txt` or `get_GEM_dictionary_from_cdc_gem_txt`, so it may be a `DataFrame` or an `OrderedDict`;
- `direction::String`: either `"I9_I10"` (from ICD-9 to ICD-10) or `"I10_I9"` (from ICD-10 to ICD-9).
"""
struct GEM{T<:Union{DataFrame,OrderedDict{String,OrderedDict{String,Any}}}} <: AbstractGEM{T}
    data::T
    direction::String

    # Inner constructor overload
    function GEM(data::T, direction::String) where {T<:Union{DataFrame,OrderedDict{String,OrderedDict{String,Any}}}}
        # Check that `direction` is either "I9_I10" or "I10_I9"
        if !(cmp(direction, "I9_I10") == 0 || cmp(direction, "I10_I9") == 0)
            error("""`direction` must be either "I9_I10" or "I10_I9".""")
        end
        # Check that the data is in the format returned by `get_gem_dataframe_from_cdc_gem_txt`
        if T == DataFrame
            if !isempty(setdiff(names(data), ("source_code", "target_code", "Approximate", "No_Map", "Combination", "Scenario", "Choice_List")))
                error("The data is not in the format returned by `get_gem_dataframe_from_cdc_gem_txt`")
            end
        elseif T == OrderedDict{String,OrderedDict{String,Any}}
            if !isempty(setdiff(vcat(unique(collect.(keys.(values(data))))...), ("Approximate", "No_Map", "Combination", "Scenario")))
                error("The data is not in the format returned by `get_GEM_dictionary_from_cdc_gem_txt`")
            end
        end
        return new{T}(data, direction)
    end

end

######## FUNCTIONS ########
"""
    get_gem_dataframe_from_cdc_gem_txt(path_to_txt::String, direction::String)

Get a `GEM{DataFrame}` object from a .txt file as downloaded from the [CDC website](https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Publications/ICD10CM/2018/Dxgem_2018.zip). `path_to_txt` is the path to the .txt file, while `direction` is the direction of the GEM file (either `"I9_I10"` or `"I10_I9"`, see [`GEM`](@ref)).
"""
function get_GEM_dataframe_from_cdc_gem_txt(path_to_txt::String, direction::String)

    # Check that `direction` is either "I9_I10" or "I10_I9"
    if !(cmp(direction, "I9_I10") == 0 || cmp(direction, "I10_I9") == 0)
        error("""`direction` must be either "I9_I10" or "I10_I9".""")
    end

    # Pre-allocate dataframe
    output_df = DataFrame(source_code=String[], target_code=String[], Approximate=Bool[], No_Map=Bool[], Combination=Bool[], Scenario=Int64[], Choice_List=Int64[])

    # Read the .txt file and add every line as a row to `output`
    open(path_to_txt) do f
        for line in eachline(f)
            line_split = filter(x -> cmp(x, "") != 0, split(line, " "))
            flags_split = split(line_split[3], "")
            push!(output_df, (line_split[1], line_split[2], parse(Bool, flags_split[1]), parse(Bool, flags_split[2]), parse(Bool, flags_split[3]), parse(Int64, flags_split[4]), parse(Int64, flags_split[5])))
        end
    end

    # Return a `GEM{DataFrame}` object
    return GEM(output_df, direction)

end

"""
    get_GEM_dict_from_GEM_dataframe(GEM_dataframe::GEM{DataFrame})

Convert a `GEM{DataFrame}` to the corresponding `GEM{OrderedDict{String, OrderedDict{String, Any}}}`.
"""
function get_GEM_dict_from_GEM_dataframe(GEM_dataframe::GEM{DataFrame})

    # Pre-allocate output
    output = OrderedDict{String,OrderedDict{String,Any}}()

    # Fill output Dict
    gem_dataframe_gby_source_code = groupby(GEM_dataframe.data, :source_code)
    for (source_code_gkey, source_code_group) in zip(keys(gem_dataframe_gby_source_code), gem_dataframe_gby_source_code)
        scenarios = OrderedDict{Int64,Vector{Tuple{Vararg{String}}}}()

        source_code_group_gby_scenario = groupby(source_code_group, :Scenario)
        for (scenario_gkey, scenario_group) in zip(keys(source_code_group_gby_scenario), source_code_group_gby_scenario)
            scenario_group_gby_choice = groupby(scenario_group, :Choice_List)
            choices = vec(collect(Iterators.product([choice_group.target_code for choice_group in scenario_group_gby_choice]...)))
            push!(scenarios, scenario_gkey.Scenario => choices)
        end

        push!(output, source_code_gkey.source_code => OrderedDict("Approximate" => source_code_group.Approximate[1], "No_Map" => source_code_group.No_Map[1], "Combination" => source_code_group.Combination[1], "Scenario" => scenarios))

    end
    # Return a `GEM{OrderedDict{String, OrderedDict{String, Any}}}` object
    return GEM(output, GEM_dataframe.direction)

end

"""
    get_GEM_dictionary_from_cdc_gem_txt(path_to_txt::String, direction::String)

Return an `OrderedDict` representing the GEM file as downloaded from the [CDC website](https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Publications/ICD10CM/2018/Dxgem_2018.zip). `path_to_txt` is the path to the .txt file, while `direction` is the direction of the GEM file (either `"I9_I10"` or `"I10_I9"`, see [`GEM`](@ref)).
"""
function get_GEM_dictionary_from_cdc_gem_txt(path_to_txt::String, direction::String)
    GEM_dataframe = get_GEM_dataframe_from_cdc_gem_txt(path_to_txt, direction)

    return get_GEM_dict_from_GEM_dataframe(GEM_dataframe)

end

"""
    get_oom(x::Union{Float64,Int64})

Get the order of magnitude of `x` as a power of 10.
"""
get_oom(x::Union{Float64,Int64}) = round(Int64, floor(log(10, x)))

"""
    get_ICD_code_range(range::String)

Get all codes of revision `revision` between `range[1]` and `range[2]`.

# Parameters

- `range::String`: must be a `String` of the form `code_1-code_2`, where code_1 and code_2 are two codes (whose revision is specified by `revision`);
- `revision::String`: must be either `"ICD-9"` or `"ICD-10"`. 
"""
function get_ICD_code_range(range::String, revision::String)
    first_idx = 0
    last_idx = 0
    endpoints = split(range, "-")
    if cmp(revision, "ICD-9") == 0
        first_idx = findfirst(x -> startswith(x, endpoints[1]), ICD_9_unique_ordered)
        last_idx = findlast(x -> startswith(x, endpoints[2]), ICD_9_unique_ordered)
        return ICD_9_unique_ordered[first_idx:last_idx]
    elseif cmp(revision, "ICD-10") == 0
        first_idx = findfirst(x -> startswith(x, endpoints[1]), ICD_10_unique_ordered)
        last_idx  = findlast(x -> startswith(x, endpoints[2]), ICD_10_unique_ordered)
        return ICD_10_unique_ordered[first_idx:last_idx]
    else
        throw(ErrorException("`revision` may be either `ICD-9` or `ICD-10`"))
    end
end

"""
    execute_applied_mapping(GEM::GEM{OrderedDict{String, OrderedDict{String, Any}}}, source_codes::Vector{String})

Translate each element of `source_codes` to the target international classification contained in `GEM` using `GEM`.
"""
function execute_applied_mapping(GEM::GEM{OrderedDict{String,OrderedDict{String,Any}}}, source_codes::Vector{String})
    returned_codes = String[]
    for source_code in source_codes
        revision = cmp(GEM.direction, "I9_I10") == 0 ? "ICD-9" : "ICD-10"
        if occursin("-", source_code)
            individual_source_codes = get_ICD_code_range(source_code, revision)
            returned_codes_dict = OrderedDict(key => val for (key, val) in collect(GEM.data) if any(startswith.(Ref(key), individual_source_codes)))
            push!(returned_codes, unique(collect(Iterators.flatten(Iterators.flatten(Iterators.flatten(vcat([values(dct["Scenario"]) for dct in values(returned_codes_dict)]...))))))...)
        else
            returned_codes_dict = OrderedDict(key => val for (key, val) in collect(GEM.data) if startswith(key, source_code))
            push!(returned_codes, unique(collect(Iterators.flatten(Iterators.flatten(Iterators.flatten(vcat([values(dct["Scenario"]) for dct in values(returned_codes_dict)]...))))))...)
        end

    end
    return returned_codes
end

####### DATA ########

const GEM_I10_I9_dataframe  = get_GEM_dataframe_from_cdc_gem_txt(joinpath(@__DIR__,"..","data","2018_I10gem.txt"),  "I10_I9")
const GEM_I10_I9_dictionary = get_GEM_dictionary_from_cdc_gem_txt(joinpath(@__DIR__,"..","data","2018_I10gem.txt"), "I10_I9")
const GEM_I9_I10_dataframe  = get_GEM_dataframe_from_cdc_gem_txt(joinpath(@__DIR__,"..","data","2018_I9gem.txt"),   "I9_I10")
const GEM_I9_I10_dictionary = get_GEM_dictionary_from_cdc_gem_txt(joinpath(@__DIR__,"..","data","2018_I9gem.txt"),  "I9_I10")

end