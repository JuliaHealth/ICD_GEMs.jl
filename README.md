# ICD_GEMs.jl 

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://github.com/JuliaHealth/ICD_GEMs.jl/blob/main/LICENSE)
[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://juliahealth.org/ICD_GEMs.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-lightblue.svg)](https://juliahealth.org/ICD_GEMs.jl/dev)
[![CI](https://github.com/JuliaHealth/ICD_GEMs.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/JuliaHealth/ICD_GEMs.jl/actions/workflows/CI.yml)
[![Compat Helper](https://github.com/JuliaGraphs/MultilayerGraphs.jl/actions/workflows/CompatHelper.yml/badge.svg)](https://github.com/JuliaGraphs/MultilayerGraphs.jl/actions/workflows/CompatHelper.yml)
[![Codecov Coverage](https://codecov.io/gh/JuliaHealth/ICD_GEMs.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/JuliaHealth/ICD_GEMs.jl)
[![Coveralls Coverage](https://coveralls.io/repos/github/JuliaHealth/ICD_GEMs.jl/badge.svg?branch=main)](https://coveralls.io/github/JuliaHealth/ICD_GEMs.jl?branch=main)
[![DOI](https://zenodo.org/badge/494094231.svg)](https://zenodo.org/badge/latestdoi/494094231)

<img align="right" width="180" height="150" src="https://github.com/JuliaHealth/ICD_GEMs.jl/blob/main/docs/src/assets/logo.png?raw=true">

ICD_GEMs.jl is a Julia package that allows to translate ICD-9 codes in ICD-10 and viceversa via the General Equivalence Mappings ([GEMs](https://www.asco.org/practice-policy/billing-coding-reporting/icd-10/general-equivalence-mappings-gems)) of the International Classification of Diseases ([ICD](https://www.who.int/standards/classifications/classification-of-diseases)).

## Overview 

### ICD

The ICD provides a common language for the classification of diseases, injuries and causes of death, and for the standardised reporting and monitoring of health conditions. It is designed to map health conditions to corresponding generic categories together with specific variations, assigning to these a designated code, up to six characters long. These data form the basis of comparison and sharing between health providers, regions and countries, and over periods.

In addition to this essential core function, the ICD can also inform a wide range of related activities. It is used for health insurance reimbursement; in national health programme management; by data collection specialists and researchers; for tracking progress in global health; and to determine the allocation of health resources. Patient quality and safety documentation is also heavily informed by the ICD.

The ICD system is designed to promote international comparability in the collection, processing, classification, and presentation of health statistics, and health information in general. Currently, 117 countries report causes of death to WHO. Seventy per cent of the world’s health resources are allocated based on ICD data. Current uses include cancer registration, pharmacovigilance, and more than 20,000 scientific articles cite ICD-10.

For further details about the ICD, please consider to read the [References](#References).

### GEMs

The General Equivalence Mappings (GEMs) are the product of a coordinated effort spanning several years and involving the National Center for Health Statistics (NCHS), the Centers for Medicare and Medicaid Services (CMS), the American Health Information Management Association (AHIMA), the American Hospital Association, and 3M Health Information Systems providing a temporary mechanism to link ICD-9 codes to ICD-10 and vice versa. 

According to the CMS: 

> The purpose of the GEMs is to create a useful, practical, code to code translation reference dictionary for both code sets, and to offer acceptable translation alternatives wherever possible. For each code set, it endeavors to answer this question: Taking the complete meaning of a code (defined as: all correctly coded conditions or procedures that would be classified to a code based on the code title, all associated tabular instructional notes, and all index references that refer to a code) as a single unit, what are the most appropriate translation(s) to the other code set?

For further details on how the GEMs work, please consider to read the [References](#References).

## Installation

Press `]` in the Julia REPL and then

```julia
pkg> add ICD_GEMs
```

## Tutorial 

Let us showcase the features of the package.

First, we import the necessary packages:

```julia
using ICD_GEMs
```

The GEMs converting ICD-10 codes into ICD-9 and viceversa have already been downloaded from [here](https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Publications/ICD10CM/2018/Dxgem_2018.zip) and exported both as `DataFrame` s from [DataFrames.jl](https://github.com/JuliaData/DataFrames.jl) and `OrderedDict`s from [DataStructures.jl](https://github.com/JuliaCollections/DataStructures.jl):

- `GEM_I10_I9_dataframe`:  GEM from ICD-10 to ICD-9 represented as a dataframe;
- `GEM_I10_I9_dictionary`:  GEM from ICD-10 to ICD-9 represented as a dictionary;
- `GEM_I9_I10_dataframe`:  GEM from ICD-9 to ICD-10 represented as a dataframe;
- `GEM_I9_I10_dictionary`:  GEM from ICD-10 to ICD-9 represented as a dictionary.

These are all `GEM` structs consisting of two fields:

- `data`: The actual GEM, which may either be a dataframe or a dictionary;
- `direction`: A string, either `"I10_I9"` or `"I9_I10"`.

The package can be used with custom GEMs (or "applied mappings") as long as they are wrapped inside a `GEM` struct where the `data` field is either a dataframe or a dictionary with the exact same format as the exported ones above. If some new GEMs are released by the [CDC](https://www.cdc.gov/nchs/icd/Comprehensive-Listing-of-ICD-10-CM-Files.htm), the functions that load CDC-formatted .txt files are exported:

```julia
path      = "path/to/txt"
direction = "I10_I9" # If the GEM translates from ICD-10 to ICD-9, otherwise "I9_I10"
gem       = get_GEM_dataframe_from_cdc_gem_txt(path, direction) # Or get_GEM_dictionary_from_cdc_gem_txt(path, direction)
```

Finally, let us show how to translate ICD-10 codes into ICD-9 for, as an example, neoplasms:

```julia
ICD_10_neoplasms = "C00-D48" # This is equivalent as explicitly specifying all codes from C00.XX to D48.XX
ICD_9_neoplasm   = execute_applied_mapping(GEM_I10_I9_dictionary, ["C00-D48"])  
```

```nothing
932-element Vector{String}:
 "1400"
 "1401"
 "1409"
 "1403"
 "1404"
 "1405"
 "1406"
 "1408"
 "1410"
 ⋮
 "23877"
 "2380"
 "2381"
 "2354"
 "2382"
 "2383"
 "2388"
 "2389"
```

And back:

```julia
ICD_10_neoplasm_back   = execute_applied_mapping(GEM_I9_I10_dictionary, ICD_9_neoplasm)
```

```nothing
1186-element Vector{String}:
 "C000"
 "C001"
 "C002"
 "C003"
 "C004"
 "C005"
 "C006"
 "C008"
 "C01"
 ⋮
 "D480"
 "D481"
 "D483"
 "D484"
 "D485"
 "D4860"
 "D487"
 "D489"
```

Are these the same as all the codes we started from, namely all ICD-10 codes from the first starting with `C00` to the last that starts with `D48` ? These would be:

```julia
get_ICD_code_range("C00-D48", "ICD-10") # Specify a code range and the revision it belongs to
```

```nothing
1622-element Vector{String}:
 "C000"
 "C001"
 "C002"
 "C003"
 "C004"
 "C005"
 "C006"
 "C008"
 "C009"
 ⋮
 "D483"
 "D484"
 "D485"
 "D4860"
 "D4861"
 "D4862"
 "D487"
 "D489"
```

No, they are more! Why? Because the mapping between the two revisions is not injective nor surjective (see the [official documentation](https://github.com/JuliaHealth/ICD_GEMs.jl/tree/main/official_gem_documentation)). 

More complex translations, involving both single codes and ranges with arbitrary precision on both ends, can be performed:

```julia
execute_applied_mapping(GEM_I10_I9_dictionary, ["I60-I661", "I670", "I672-I679"])
```

**Note**: All codes must be specified and are returned by the translation utilities without punctuation (no dot before the decimal digits).

## How to Contribute

If you wish to change or add some functionality, please file an [issue](https://github.com/JuliaHealth/ICD_GEMs.jl/issues). 

## How to Cite 

If you use this package in your work, please cite this repository using the metadata in [`CITATION.bib`](https://github.com/JuliaHealth/ICD_GEMs.jl/blob/main/CITATION.bib).

## Announcements 

- [Twitter](https://twitter.com/In_Phy_T/status/1529444377281671168?s=20&t=O7f9qRLdsyY8WM3TEdCWLg)
- [Discourse](https://discourse.julialang.org/t/ann-icd-gems-jl-a-package-to-translate-between-icd-9-and-icd-10-codes/81679?u=pietromonticone)
- [Forem](https://forem.julialang.org/inphyt/ann-icdgemsjl-a-package-to-translate-between-icd-9-and-icd-10-codes-17am)

## References 

- Butler (2007), [ICD-10 General Equivalence Mappings: Bridging the Translation Gap from ICD-9](https://library.ahima.org/doc?oid=74265#.Ynre9i8RoiM), *Journal of AHIMA*
- CMS (2018), [2018 ICD-10 CM and GEMs](https://www.cms.gov/Medicare/Coding/ICD10/2018-ICD-10-CM-and-GEMs)
- NCHS-CDC (2018), [Diagnosis Code Set General Equivalence Mappings: ICD-10-CM to ICD-9-CM and ICD-9-CM to ICD-10-CM](https://ftp.cdc.gov/pub/health_statistics/nchs/publications/ICD10CM/2018/Dxgem_guide_2018.pdf) 
- NCHS-CDC (2022), [Comprehensive Listing ICD-10-CM Files](https://www.cdc.gov/nchs/icd/Comprehensive-Listing-of-ICD-10-CM-Files.htm) (download General Equivalence Mappings [here](https://ftp.cdc.gov/pub/Health_Statistics/NCHS/Publications/ICD10CM/2018/Dxgem_2018.zip))
- WHO (2022), [ICD-11 Implementation or Transition Guide](https://icd.who.int/docs/ICD-11%20Implementation%20or%20Transition%20Guide_v105.pdf)