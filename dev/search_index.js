var documenterSearchIndex = {"docs":
[{"location":"","page":"Home","title":"Home","text":"CurrentModule = ICD_GEMs","category":"page"},{"location":"","page":"Home","title":"Home","text":"<div style=\"width:100%; height:150px;border-width:4px;border-style:solid;padding-top:25px;\n        border-color:#000;border-radius:10px;text-align:center;background-color:#B3D8FF;\n        color:#000\">\n    <h3 style=\"color: black;\">Star us on GitHub!</h3>\n    <a class=\"github-button\" href=\"https://github.com/JuliaHealth/ICD_GEMs.jl\" data-icon=\"octicon-star\" data-size=\"large\" data-show-count=\"true\" aria-label=\"Star JuliaHealth/ICD_GEMs.jl on GitHub\" style=\"margin:auto\">Star</a>\n    <script async defer src=\"https://buttons.github.io/buttons.js\"></script>\n</div>","category":"page"},{"location":"#ICD_GEMs.jl","page":"Home","title":"ICD_GEMs.jl","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"ICD_GEMs.jl is a Julia package that allows to translate ICD-9 codes in ICD-10 and viceversa via the General Equivalence Mappings (GEMs) of the International Classification of Diseases (ICD).","category":"page"},{"location":"#Overview","page":"Home","title":"Overview","text":"","category":"section"},{"location":"#ICD","page":"Home","title":"ICD","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"The ICD provides a common language for the classification of diseases, injuries and causes of death, and for the standardised reporting and monitoring of health conditions. It is designed to map health conditions to corresponding generic categories together with specific variations, assigning to these a designated code, up to six characters long. These data form the basis of comparison and sharing between health providers, regions and countries, and over periods.","category":"page"},{"location":"","page":"Home","title":"Home","text":"In addition to this essential core function, the ICD can also inform a wide range of related activities. It is used for health insurance reimbursement; in national health programme management; by data collection specialists and researchers; for tracking progress in global health; and to determine the allocation of health resources. Patient quality and safety documentation is also heavily informed by the ICD.","category":"page"},{"location":"","page":"Home","title":"Home","text":"The ICD system is designed to promote international comparability in the collection, processing, classification, and presentation of health statistics, and health information in general. Currently, 117 countries report causes of death to WHO. Seventy per cent of the world’s health resources are allocated based on ICD data. Current uses include cancer registration, pharmacovigilance, and more than 20,000 scientific articles cite ICD-10.","category":"page"},{"location":"","page":"Home","title":"Home","text":"For further details about the ICD, please consider to read the References.","category":"page"},{"location":"#GEMs","page":"Home","title":"GEMs","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"The General Equivalence Mappings (GEMs) are the product of a coordinated effort spanning several years and involving the National Center for Health Statistics (NCHS), the Centers for Medicare and Medicaid Services (CMS), the American Health Information Management Association (AHIMA), the American Hospital Association, and 3M Health Information Systems providing a temporary mechanism to link ICD-9 codes to ICD-10 and vice versa. ","category":"page"},{"location":"","page":"Home","title":"Home","text":"According to the CMS: ","category":"page"},{"location":"","page":"Home","title":"Home","text":"The purpose of the GEMs is to create a useful, practical, code to code translation reference dictionary for both code sets, and to offer acceptable translation alternatives wherever possible. For each code set, it endeavors to answer this question: Taking the complete meaning of a code (defined as: all correctly coded conditions or procedures that would be classified to a code based on the code title, all associated tabular instructional notes, and all index references that refer to a code) as a single unit, what are the most appropriate translation(s) to the other code set?","category":"page"},{"location":"","page":"Home","title":"Home","text":"For further details on how the GEMs work, please consider to read the References.","category":"page"},{"location":"#Installation","page":"Home","title":"Installation","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Press ] in the Julia REPL and then","category":"page"},{"location":"","page":"Home","title":"Home","text":"pkg> add ICD_GEMs","category":"page"},{"location":"#Tutorial","page":"Home","title":"Tutorial","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Let us showcase the features of the package.","category":"page"},{"location":"","page":"Home","title":"Home","text":"First, we import the necessary packages:","category":"page"},{"location":"","page":"Home","title":"Home","text":"using ICD_GEMs","category":"page"},{"location":"","page":"Home","title":"Home","text":"The GEMs converting ICD-10 codes into ICD-9 and viceversa have already been downloaded from here and exported both as DataFrame s from DataFrames.jl and OrderedDicts from DataStructures.jl:","category":"page"},{"location":"","page":"Home","title":"Home","text":"GEM_I10_I9_dataframe:  GEM from ICD-10 to ICD-9 represented as a dataframe;\nGEM_I10_I9_dictionary:  GEM from ICD-10 to ICD-9 represented as a dictionary;\nGEM_I9_I10_dataframe:  GEM from ICD-9 to ICD-10 represented as a dataframe;\nGEM_I9_I10_dictionary:  GEM from ICD-10 to ICD-9 represented as a dictionary.","category":"page"},{"location":"","page":"Home","title":"Home","text":"These are all GEM structs consisting of two fields:","category":"page"},{"location":"","page":"Home","title":"Home","text":"data: The actual GEM, which may either be a dataframe or a dictionary;\ndirection: A string, either \"I10_I9\" or \"I9_I10\".","category":"page"},{"location":"","page":"Home","title":"Home","text":"The package can be used with custom GEMs (or \"applied mappings\") as long as they are wrapped inside a GEM struct where the data field is either a dataframe or a dictionary with the exact same format as the exported ones above. If some new GEMs are released by the CDC, the functions that load CDC-formatted .txt files are exported:","category":"page"},{"location":"","page":"Home","title":"Home","text":"path      = \"path/to/txt\"\ndirection = \"I10_I9\" # If the GEM translates from ICD-10 to ICD-9, otherwise \"I9_I10\"\ngem       = get_GEM_dataframe_from_cdc_gem_txt(path, direction) # Or get_GEM_dictionary_from_cdc_gem_txt(path, direction)","category":"page"},{"location":"","page":"Home","title":"Home","text":"Finally, let us show how to translate ICD-10 codes into ICD-9 for, as an example, neoplasms:","category":"page"},{"location":"","page":"Home","title":"Home","text":"ICD_10_neoplasms = \"C00-D48\" # This is equivalent as explicitly specifying all codes from C00.XX to D48.XX\nICD_9_neoplasms   = execute_applied_mapping(GEM_I10_I9_dictionary, [\"C00-D48\"])  ","category":"page"},{"location":"","page":"Home","title":"Home","text":"932-element Vector{String}:\n \"1400\"\n \"1401\"\n \"1409\"\n \"1403\"\n \"1404\"\n \"1405\"\n \"1406\"\n \"1408\"\n \"1410\"\n ⋮\n \"23877\"\n \"2380\"\n \"2381\"\n \"2354\"\n \"2382\"\n \"2383\"\n \"2388\"\n \"2389\"","category":"page"},{"location":"","page":"Home","title":"Home","text":"And back:","category":"page"},{"location":"","page":"Home","title":"Home","text":"ICD_10_neoplasms_back   = execute_applied_mapping(GEM_I9_I10_dictionary, ICD_9_neoplasms)","category":"page"},{"location":"","page":"Home","title":"Home","text":"1186-element Vector{String}:\n \"C000\"\n \"C001\"\n \"C002\"\n \"C003\"\n \"C004\"\n \"C005\"\n \"C006\"\n \"C008\"\n \"C01\"\n ⋮\n \"D480\"\n \"D481\"\n \"D483\"\n \"D484\"\n \"D485\"\n \"D4860\"\n \"D487\"\n \"D489\"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Are these the same as all the codes we started from, namely all ICD-10 codes from the first starting with C00 to the last that starts with D48 ? These would be:","category":"page"},{"location":"","page":"Home","title":"Home","text":"get_ICD_code_range(\"C00-D48\", \"ICD-10\") # Specify a code range and the revision it belongs to","category":"page"},{"location":"","page":"Home","title":"Home","text":"1622-element Vector{String}:\n \"C000\"\n \"C001\"\n \"C002\"\n \"C003\"\n \"C004\"\n \"C005\"\n \"C006\"\n \"C008\"\n \"C009\"\n ⋮\n \"D483\"\n \"D484\"\n \"D485\"\n \"D4860\"\n \"D4861\"\n \"D4862\"\n \"D487\"\n \"D489\"","category":"page"},{"location":"","page":"Home","title":"Home","text":"No, they are more! Why? Because the mapping between the two revisions is not injective nor surjective (see the official documentation). ","category":"page"},{"location":"","page":"Home","title":"Home","text":"More complex translations, involving both single codes and ranges with arbitrary precision on both ends, can be performed:","category":"page"},{"location":"","page":"Home","title":"Home","text":"execute_applied_mapping(GEM_I10_I9_dictionary, [\"I60-I661\", \"I670\", \"I672-I679\"])","category":"page"},{"location":"","page":"Home","title":"Home","text":"note: Note\nAll codes must be specified and are returned by the translation utilities without punctuation (no dot before the decimal digits).","category":"page"},{"location":"#How-to-Contribute","page":"Home","title":"How to Contribute","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"If you wish to change or add some functionality, please file an issue. ","category":"page"},{"location":"#How-to-Cite","page":"Home","title":"How to Cite","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"If you use this package in your work, please cite this repository using the metadata in CITATION.bib.","category":"page"},{"location":"#References","page":"Home","title":"References","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Butler (2007), ICD-10 General Equivalence Mappings: Bridging the Translation Gap from ICD-9, Journal of AHIMA\nCMS (2018), 2018 ICD-10 CM and GEMs\nNCHS-CDC (2018), Diagnosis Code Set General Equivalence Mappings: ICD-10-CM to ICD-9-CM and ICD-9-CM to ICD-10-CM \nNCHS-CDC (2022), Comprehensive Listing ICD-10-CM Files (download General Equivalence Mappings here)\nWHO (2022), ICD-11 Implementation or Transition Guide","category":"page"},{"location":"API/#API","page":"API","title":"API","text":"","category":"section"},{"location":"API/","page":"API","title":"API","text":"","category":"page"},{"location":"API/","page":"API","title":"API","text":"Modules = [ICD_GEMs]","category":"page"},{"location":"API/#ICD_GEMs.AbstractGEM","page":"API","title":"ICD_GEMs.AbstractGEM","text":"AbstractGEM{T}\n\nAn abstract type representing a General Equivalence Map (GEM). T is the type of the low-level data structure used to represent the GEM.\n\n\n\n\n\n","category":"type"},{"location":"API/#ICD_GEMs.GEM","page":"API","title":"ICD_GEMs.GEM","text":"struct GEM{T <: Union{DataFrame, OrderedDict{String, OrderedDict{String, Any}}}}\n\nRepresents a General Equivalence Map (GEM) table.\n\nFIELDS\n\ndata<: Union{DataFrame,OrderedDict{String, OrderedDict{String, Any}}}: the actual GEM data, as returned by get_gem_dataframe_from_cdc_gem_txt or get_GEM_dictionary_from_cdc_gem_txt, so it may be a DataFrame or an OrderedDict;\ndirection::String: either \"I9_I10\" (from ICD-9 to ICD-10) or \"I10_I9\" (from ICD-10 to ICD-9).\n\n\n\n\n\n","category":"type"},{"location":"API/#ICD_GEMs.execute_applied_mapping-Tuple{GEM{OrderedCollections.OrderedDict{String, OrderedCollections.OrderedDict{String, Any}}}, Vector{String}}","page":"API","title":"ICD_GEMs.execute_applied_mapping","text":"execute_applied_mapping(GEM::GEM{OrderedDict{String, OrderedDict{String, Any}}}, source_codes::Vector{String})\n\nTranslate each element of source_codes to the target international classification contained in GEM using GEM.\n\n\n\n\n\n","category":"method"},{"location":"API/#ICD_GEMs.get_GEM_dataframe_from_cdc_gem_txt-Tuple{String, String}","page":"API","title":"ICD_GEMs.get_GEM_dataframe_from_cdc_gem_txt","text":"get_gem_dataframe_from_cdc_gem_txt(path_to_txt::String, direction::String)\n\nGet a GEM{DataFrame} object from a .txt file as downloaded from the CDC website. path_to_txt is the path to the .txt file, while direction is the direction of the GEM file (either \"I9_I10\" or \"I10_I9\", see GEM).\n\n\n\n\n\n","category":"method"},{"location":"API/#ICD_GEMs.get_GEM_dict_from_GEM_dataframe-Tuple{GEM{DataFrames.DataFrame}}","page":"API","title":"ICD_GEMs.get_GEM_dict_from_GEM_dataframe","text":"get_GEM_dict_from_GEM_dataframe(GEM_dataframe::GEM{DataFrame})\n\nConvert a GEM{DataFrame} to the corresponding GEM{OrderedDict{String, OrderedDict{String, Any}}}.\n\n\n\n\n\n","category":"method"},{"location":"API/#ICD_GEMs.get_GEM_dictionary_from_cdc_gem_txt-Tuple{String, String}","page":"API","title":"ICD_GEMs.get_GEM_dictionary_from_cdc_gem_txt","text":"get_GEM_dictionary_from_cdc_gem_txt(path_to_txt::String, direction::String)\n\nReturn an OrderedDict representing the GEM file as downloaded from the CDC website. path_to_txt is the path to the .txt file, while direction is the direction of the GEM file (either \"I9_I10\" or \"I10_I9\", see GEM).\n\n\n\n\n\n","category":"method"},{"location":"API/#ICD_GEMs.get_ICD_code_range-Tuple{String, String}","page":"API","title":"ICD_GEMs.get_ICD_code_range","text":"get_ICD_code_range(range::String)\n\nGet all codes of revision revision between range[1] and range[2].\n\nParameters\n\nrange::String: must be a String of the form code_1-code_2, where code1 and code2 are two codes (whose revision is specified by revision);\nrevision::String: must be either \"ICD-9\" or \"ICD-10\". \n\n\n\n\n\n","category":"method"},{"location":"API/#ICD_GEMs.get_oom-Tuple{Union{Float64, Int64}}","page":"API","title":"ICD_GEMs.get_oom","text":"get_oom(x::Union{Float64,Int64})\n\nGet the order of magnitude of x as a power of 10.\n\n\n\n\n\n","category":"method"}]
}
