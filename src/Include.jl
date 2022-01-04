# setup internal paths -
_PATH_TO_SRC = dirname(pathof(@__MODULE__))

# load external packages that we depend upon -
using Reexport
@reexport using DataFrames
@reexport using CSV
using HTTP
using TOML
using Dates
using JSON

# load my codes -
include(joinpath(_PATH_TO_SRC,"Types.jl"))
include(joinpath(_PATH_TO_SRC,"Base.jl"))
include(joinpath(_PATH_TO_SRC,"Network.jl"))
include(joinpath(_PATH_TO_SRC,"Factory.jl"))
include(joinpath(_PATH_TO_SRC,"Handler.jl"))