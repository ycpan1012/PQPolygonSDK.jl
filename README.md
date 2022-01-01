![CI](https://github.com/Paliquant/PQPolygonSDK.jl/workflows/CI/badge.svg)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Introduction
`PQPolygonSDK.jl` is a software development kit (SDK) for the [Polygon.io](https://polygon.io) financial data warehouse in the [Julia](https://julialang.org) programming language. [Polygon.io](https://polygon.io) is a leading provider of realtime and historical stock, options, forex (FX) data, and digital/crypto currency data feeds.

## Installation and Requirements
`PQPolygonSDK.jl` can be installed, updated, or removed using the [Julia package management system](https://docs.julialang.org/en/v1/stdlib/Pkg/). To access the package management interface, open the [Julia REPL](https://docs.julialang.org/en/v1/stdlib/REPL/), and start the package mode by pressing `]`.
While in package mode, to install `PQPolygonSDK.jl`, issue the command:

    (@v1.7.x) pkg> add PQPolygonSDK

To use `PQPolygonSDK.jl` in your projects, issue the command:

    julia> using PQPolygonSDK

## Quick Start Guide
All [Polygon.io](https://polygon.io) application programming interface (API) calls start by creating a `PQPolygonSDKUserModel` using the


```julia    
model(userModelType::Type{PQPolygonSDKUserModel}, options::Dict{String,Any}) -> PQPolygonSDKUserModel
```
    

function where the `options` dictionary holds `email` and `apikey` key value pairs. Once a user model has been created, that model
is passed into an API endpoint specific `build` method:

    model(apiModelType::Type{T}, userModel::PQPolygonSDKUserModel, 
        options::Dict{String,Any}) -> AbstractPolygonEndpointModel where T<:AbstractPolygonEndpointModel



