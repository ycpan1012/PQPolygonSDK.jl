mutable struct PQPolygonSDKUserModel

    # data about the user -
    email::String
    apikey::String

    PQPolygonSDKUserModel() = new()
end

# what is the base type for all endpoint calls?
abstract type AbstractPolygonEndpointModel end

mutable struct PolygonGroupedDailyEndpointModel <: AbstractPolygonEndpointModel

    # data -
    date::Date
    adjusted::Bool
    apikey::String
    
    # constructor -
    PolygonGroupedDailyEndpointModel() = new()
end

mutable struct PolygonDailyOpenCloseEndpointModel <: AbstractPolygonEndpointModel

    # data -
    ticker::String
    adjusted::Bool
    date::Date
    apikey::String

    # constructor -
    PolygonDailyOpenCloseEndpointModel() = new()
end

mutable struct PolygonPreviousCloseEndpointModel <: AbstractPolygonEndpointModel

    # data -
    ticker::String
    adjusted::Bool
    apikey::String

    # constructor -
    PolygonPreviousCloseEndpointModel() = new()
end

mutable struct PolygonAggregatesEndpointModel <: AbstractPolygonEndpointModel

    # data -
    adjusted::Bool
    limit::Int64
    sortdirection::String
    ticker::String
    to::Date
    from::Date
    multiplier::Int64
    timespan::String
    apikey::String

    # constructor -
    PolygonAggregatesEndpointModel() = new()
end


mutable struct PolygonTickerNewsEndpointModel <: AbstractPolygonEndpointModel

    # data -
    ticker::String
    published_utc::Union{Date, Nothing}
    order::String
    limit::Int64
    sort::Union{String, Nothing}
    apikey::String

    # constructor -
    PolygonTickerNewsEndpointModel() = new()
end

mutable struct PolygonTickerDetailsEndpointModel <: AbstractPolygonEndpointModel

    # data -
    apikey::String
    ticker::String
    date::Date #ycpan
    # constructor -
    PolygonTickerDetailsEndpointModel() = new()
end

mutable struct PolygonOptionsContractReferenceEndpoint <: AbstractPolygonEndpointModel

    # data -
    ticker::Union{Nothing,String}
    underlying_ticker::Union{Nothing, String}
    contract_type::String
    expiration_date::Date
    limit::Int64
    order::String
    sort::String
    apikey::String

    # constructor -
    PolygonOptionsContractReferenceEndpoint() = new()
end

mutable struct PolygonMarketHolidaysEndpointModel <: AbstractPolygonEndpointModel #ycpan

    # data -
    apikey::String    

    # constructor -
    PolygonMarketHolidaysEndpointModel() = new()
end

mutable struct PolygonExchangesEndpointModel <: AbstractPolygonEndpointModel #ycpan

    # data -
    apikey::String
    asset_class::String
    locale::String
    
    # constructor -
    PolygonExchangesEndpointModel() = new()
end

mutable struct PolygonStockSplitsEndpointModel <: AbstractPolygonEndpointModel #ycpan

    # data -
    apikey::String
    ticker::String
    execution_date::String
    reverse_split::String
    order::String
    limit::String
    sort::String
    
    # constructor -
    PolygonStockSplitsEndpointModel() = new()
end

mutable struct PolygonMarketStatusEndpointModel <: AbstractPolygonEndpointModel #yc

    # data - 
    apikey::String    

    # constructor -
    PolygonMarketStatusEndpointModel() = new()
end
