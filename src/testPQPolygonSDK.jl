module testPQPolygonSDK

# include -
include("Include.jl")

# methods and types that we export -
export model
export url
export api

# types -
export AbstractPolygonEndpointModel
export PQPolygonSDKUserModel

# market endpoints -
export PolygonPreviousCloseEndpointModel
export PolygonAggregatesEndpointModel
export PolygonOptionsContractReferenceEndpoint
export PolygonGroupedDailyEndpointModel
export PolygonDailyOpenCloseEndpointModel
export PolygonMarketHolidaysEndpointModel #ycpan
export PolygonExchangesEndpointModel #ycpan

# reference endpoints -
export PolygonTickerNewsEndpointModel
export PolygonTickerDetailsEndpointModel


end # module
