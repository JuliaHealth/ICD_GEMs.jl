using ICD_GEMs
using Test

@testset "ICD_GEMs.jl" begin
    # Instantiate GEMs in various ways
    gem_dataframe_loaded      = get_GEM_dataframe_from_cdc_gem_txt(joinpath(@__DIR__,"..","data","2018_I10gem.txt"), "I10_I9")
    gem_dataframe_constructed = GEM(gem_dataframe_loaded.data,gem_dataframe_loaded.direction)
    gem_dictionary_converted  = get_GEM_dict_from_GEM_dataframe(gem_dataframe_loaded)
    gem_dictionary_loaded     = get_GEM_dictionary_from_cdc_gem_txt(joinpath(@__DIR__,"..","data","2018_I9gem.txt"), "I9_I10")
    # Test code ranges
    ## ICD-10
    @test all(get_ICD_code_range("C00-C10", "ICD-10") .==  ["C000", "C001", "C002", "C003", "C004", "C005", "C006", "C008", "C009", "C01", "C020", "C021", "C022", "C023", "C024", "C028", "C029", "C030", "C031", "C039", "C040", "C041", "C048", "C049", "C050", "C051", "C052", "C058", "C059", "C060", "C061", "C062", "C0680", "C0689", "C069", "C07", "C080", "C081", "C089", "C090", "C091", "C098", "C099", "C100", "C101", "C102", "C103", "C104", "C108", "C109"])
    ## ICD-9
    @test all(get_ICD_code_range("0010-0050", "ICD-9") .== ["0010", "0011", "0019", "0020", "0021", "0022", "0023", "0029", "0030", "0031", "00320", "00321", "00322", "00323", "00324", "00329", "0038", "0039", "0040", "0041", "0042", "0043", "0048", "0049", "0050"])
    # Test conversions
    ## ICD-10 -> ICD-9
    @test all(execute_applied_mapping(GEM_I10_I9_dictionary, ["I60-I661", "I670", "I672-I679"]) .== ["430", "431", "4321", "4320", "4329", "43391", "43321", "43301", "43311", "43381", "43401", "43411", "43491", "43331", "43320", "43300", "43310", "43380", "43390", "43400", "43410", "43490", "44329", "4370", "0463", "4372", "4375", "4376", "4374", "4371", "34839", "4359", "436", "4378", "4379"])
    ## ICD-9 -> ICD-10
    @test all(execute_applied_mapping(GEM_I9_I10_dictionary, ["0010-0050", "0800", "020-0030"]) .== ["A000", "A001", "A009", "A0100", "A011", "A012", "A013", "A014", "A020", "A021", "A0220", "A0221", "A0222", "A0223", "A0224", "A0229", "A028", "A029", "A030", "A031", "A032", "A033", "A038", "A039", "A050"])
end