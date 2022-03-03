using testPQPolygonSDK
using Dates
using DataFrames

# build a user model -
options = Dict{String,Any}()
options["email"] = "yp392@cornell.edu"
options["apikey"] = "abc12345" # do _not_ check in a real API key 

# build the user model -
user_model = model(PQPolygonSDKUserModel, options)

# now that we have the user_model, let's build an endpoint model -
endpoint_options = Dict{String,Any}()
endpoint_options["ticker"] = "AAPL"
endpoint_options["date"] = "N/A"
endpoint_model = model(PolygonTickerDetailsEndpointModel, user_model, endpoint_options)

# build the url -
base = "https://api.polygon.io"
my_url_string = url(base, endpoint_model)

# make the call -
(header, data) = api(PolygonTickerDetailsEndpointModel, my_url_string)
