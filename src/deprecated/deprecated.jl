"""
    truncate_code(code::String, n_digits::Union{Int64,Nothing}) 

Tuncate code after n digits, and treat digits beyond the third as decimals. Convert to Float64 before returning.
"""
function truncate_code(code::String, n_digits::Union{Int64,Nothing})
    if !occursin("V", code) && !occursin("E", code) && !occursin("NoDx", code)
        truncated_code = !isnothing(n_digits) ? code[1:n_digits] : code
        return parse(Float64, truncated_code[1:3] * "." * truncated_code[4:end])
    else
        return Inf
    end
end


# Substituted by get_ICD_code_range, that orks for both ICD_9_CM and ICD_10
"""
    get_ICD10_code_range(code_range::String)

Get all ICD-10 codes between the two ICD-10codes in `code_range`, which must be a string containing the two codes separeted by a '-'. The elements of the returned array have as many decimal places as there are in the first code of `code_range`.
"""
function get_ICD10_code_range(code_range::String)
    endpoints = split(code_range, "-")
    prefix_end = findlast(c -> !isdigit(c), endpoints[1])
    println("prefix_end = $prefix_end")
    letter = nothing
    if !isnothing(prefix_end)
        letter = endpoints[1][prefix_end]
    else
        error("The code $(endpoints[1]) is not an ICD-10 code")
    end

    numeric_portion_start = length(endpoints[1][(prefix_end+3):end]) > 0 ? parse(Float64, endpoints[1][(prefix_end+1):3] * "." * endpoints[1][(prefix_end+3):end]) : parse(Int64, endpoints[1][(prefix_end+1):3])
    numeric_portion_end = length(endpoints[2][(prefix_end+3):end]) > 0 ? parse(Float64, endpoints[2][(prefix_end+1):3] * "." * endpoints[2][(prefix_end+3):end]) : parse(Int64, endpoints[2][(prefix_end+1):3])
    step = length(endpoints[2][(prefix_end+3):end]) == 0 ? 1 : round(10^(-length(endpoints[2][(prefix_end+3):end])), digits=length(endpoints[2][(prefix_end+3):end]))

    numeric_codes = numeric_portion_start:step:numeric_portion_end
    codes = [get_oom(numeric_code) > 0 ? replace(letter * string(numeric_code), "." => "") : replace(letter * "0" * string(numeric_code), "." => "") for numeric_code in numeric_codes]
    #println("codes = $codes, step = $step")
    return codes
end


"""
    get_ICD_code_range(code_range::String)

Get all ICD (9_CM or 10) codes between the two ICD codes in `code_range`, which must be a string containing the two codes separeted by a '-'. The elements of the returned array have as many decimal places as there are in the first code of `code_range`.

Note that if it is an ICD_9_CM code range, then either both endpoints must be numbers (i.e. from 00100 to 99999) or they must present the same initial letter (E, V, etc).
    
If it is an ICD_10 code range, then the initial non-numeric part of both endpoints must be the same. Note that there are exceptional codes like `M97.01XA` or `M97.8XXA` for which a notion of ordering (and so a notion of "range") is not easily defined, so this function is ony able to produce ranges of codes that are all of the form "(letter)(numeric code)".

# Examples

## ICD_9_CM code ranges

get_ICD_code_range("001-029")  #ok
get_ICD_code_range("001-0290") #ok
get_ICD_code_range("0037-029") #ok
get_ICD_code_range("001-V029") # ERROR
get_ICD_code_range("V001-E029") # ERROR

## ICD_10 code ranges
get_ICD_code_range("A00-A39")    #ok
get_ICD_code_range("C223-C50")   #ok
get_ICD_code_range("C00-D50")    # ERROR


"""
function get_ICD_code_range(code_range::String)
    endpoints = split(code_range, "-")
    l1 = length(endpoints[1])
    l2 = length(endpoints[2])
    diff_length = abs(l1 - l2)

    # Pad the shortest between l1 and l2 with as many "0"s as needed to match the length of the longer.
    if l1 > l2
        endpoints[2] = endpoints[2] * ("0"^diff_length)
    else
        endpoints[1] = endpoints[1] * ("0"^diff_length)
    end

    # Get the index of the last non-numeric char of the first endpoint. If there is no non-numeric character, then `last_char_idx` = 0
    last_char_idx = findlast(c -> !isdigit(c), endpoints[1])
    last_char_idx = isnothing(last_char_idx) ? 0 : last_char_idx

    # Get the last non-numeric character of the first endpoint, if there is no non-numeric character, then `letter` = ""
    letter = last_char_idx != 0 ? endpoints[1][1:last_char_idx] : ""
    #  Get the number of numeric characters in the code
    num_digits = length(endpoints[1][(last_char_idx+1):end])

    if last_char_idx != 0
        cmp(endpoints[1][1:last_char_idx], endpoints[2][1:last_char_idx]) == 0 ? nothing : error("Invalid range")
    end

    numeric_portion_start = isnothing(letter) ? parse(Int64, endpoints[1]) : parse(Int64, endpoints[1][(last_char_idx+1):end])
    numeric_portion_end = isnothing(letter) ? parse(Int64, endpoints[2]) : parse(Int64, endpoints[2][(last_char_idx+1):end])

    # numeric_portion_start = length(endpoints[1][4:end]) > 0 ? parse(Float64, endpoints[1][2:3]*"."*endpoints[1][4:end]) : parse(Int64, endpoints[1][2:3])
    # numeric_portion_end = length(endpoints[2][4:end]) > 0 ? parse(Float64, endpoints[2][2:3]*"."*endpoints[2][4:end]) : parse(Int64, endpoints[2][2:3])
    #step = length(endpoints[1][4:end]) == 0 ? 1 : round(10^(-length(endpoints[1][4:end])), digits =  length(endpoints[1][4:end]))

    numeric_codes = numeric_portion_start:numeric_portion_end
    codes = [letter * ("0"^(numeric_code > 0 ? num_digits - get_oom(numeric_code) - 1 : num_digits - 1) * string(numeric_code)) for numeric_code in numeric_codes] #[get_oom(numeric_code) > 2 ? replace(letter*string(numeric_code), "."=> "") : replace(letter*"0"*string(numeric_code), "."=> "") for numeric_code in numeric_codes]
    #println("codes = $codes, step = $step")
    return codes
end