function _add_parameters_to_url_query_string(base::String, options::Dict{String,Any})::String

    # init -
    url_string = base

    parameters = ""
    for (key, value) in options
        parameters *= "$(key)=$(value)&"
    end

    # cut off trailing &
    query_parameters = parameters[1:end-1]

    # return -
    return url_string * query_parameters
end


function model(userModelType::Type{PQPolygonSDKUserModel}, 
    options::Dict{String,Any})::PQPolygonSDKUserModel

    # initialize -
    user_model = PQPolygonSDKUserModel()

    # for the result of the fields, let's lookup in the dictionary.
    # error state: if the dictionary is missing a value -
    for field_name_symbol ∈ fieldnames(userModelType)
        
        # convert the field_name_symbol to a string -
        field_name_string = string(field_name_symbol)
        
        # check the for the key -
        if (haskey(options,field_name_string) == false)
            throw(ArgumentError("dictionary is missing: $(field_name_string)"))    
        end

        # get the value -
        value = options[field_name_string]

        # set -
        setproperty!(user_model,field_name_symbol,value)
    end

    # return -
    return user_model
end

function model(apiModelType::Type{T}, 
    userModel::PQPolygonSDKUserModel, 
    options::Dict{String,Any})::AbstractPolygonEndpointModel where T<:AbstractPolygonEndpointModel

    # initialize -
    model = eval(Meta.parse("$(apiModelType)()")) # empty endpoint model -

    # grab the apikey from the user object -
    apikey = userModel.apikey
    model.apikey = apikey

    # for the result of the fields, let's lookup in the dictionary.
    # error state: if the dictionary is missing a value -
    for field_name_symbol ∈ fieldnames(apiModelType)
        
        # skip apikey - we already set that
        if (field_name_symbol != :apikey)
            
            # convert the field_name_symbol to a string -
            field_name_string = string(field_name_symbol)
        
            # check the for the key -
            if (haskey(options,field_name_string) == false)
                throw(ArgumentError("dictionary is missing: $(field_name_string)"))    
            end

            # get the value -
            value = options[field_name_string]

            # set -
            setproperty!(model,field_name_symbol,value)
        end
    end

    # return -
    return model
end

# -- URL FACTORY METHODS BELOW HERE --------------------------------------------------- #
function url(base::String, model::PolygonTickerNewsEndpointModel; 
    apiversion::Int = 2)::String

    # get data from the API call data -
    apikey = model.apikey
    ticker = model.ticker
    limit = model.limit
    order = model.order

    # check: do we have a published_utc parameter?
    published_utc = nothing
    if (isnothing(model.published_utc) == false)
        published_utc = model.published_utc
    end

    # check: do we have a sort parameter?
    sort = nothing
    if (isnothing(model.sort) == false)
        sort = model.sort
    end

    # build up the base string -
    base_url = "$(base)/v$(apiversion)/reference/news?"

    # what keys are passed as parameters?
    options_dictionary = Dict{String,Any}()
	options_dictionary["apiKey"] = apikey
    options_dictionary["limit"] = limit
    options_dictionary["order"] = order
    options_dictionary["ticker"] = ticker

    # do we have sort data?
    if (isnothing(sort) == false)
        options_dictionary["order"] = sort
    end

    # do we have published_utc data?
    if (isnothing(published_utc) == false)
        options_dictionary["published_utc"] = published_utc
    end

    # return -
    return _add_parameters_to_url_query_string(base_url, options_dictionary)
end

function url(base::String, model::PolygonDailyOpenCloseEndpointModel; 
    apiversion::Int = 1)::String

    # get data from the API call data -
    adjusted = model.adjusted
    apikey = model.apikey
    date = model.date
    ticker = model.ticker

    # build up the base string -
    base_url = "$(base)/v$(apiversion)/open-close/$(ticker)/$(date)?"

    # what keys are passed as parameters?
    options_dictionary = Dict{String,Any}()
	options_dictionary["adjusted"] = adjusted
	options_dictionary["apiKey"] = apikey

    # return -
    return _add_parameters_to_url_query_string(base_url, options_dictionary)
end

function url(base::String, model::PolygonGroupedDailyEndpointModel; 
    apiversion::Int = 2)::String

    # get data from the API call data -
    adjusted = model.adjusted
    apikey = model.apikey
    date = model.date

    # build up the base string -
    base_url = "$(base)/v$(apiversion)/aggs/grouped/locale/us/market/stocks/$(date)?"

    # what keys are passed as parameters?
    options_dictionary = Dict{String,Any}()
	options_dictionary["adjusted"] = adjusted
	options_dictionary["apiKey"] = apikey

    # return -
    return _add_parameters_to_url_query_string(base_url, options_dictionary)
end

function url(base::String, model::PolygonPreviousCloseEndpointModel; 
    apiversion::Int = 2)::String

    # get data from the API call data -
    adjusted = model.adjusted
    apikey = model.apikey
    ticker = model.ticker
    
    # build up the base string -
    base_url = "$(base)/v$(apiversion)/aggs/ticker/$(ticker)/prev?"

    # what keys are passed as parameters?
    options_dictionary = Dict{String,Any}()
	options_dictionary["adjusted"] = adjusted
	options_dictionary["apiKey"] = apikey

    # return -
    return _add_parameters_to_url_query_string(base_url, options_dictionary)
end

function url(base::String, model::PolygonAggregatesEndpointModel; 
    apiversion::Int = 2)::String

    # get data from the API call data -
    adjusted = model.adjusted
    limit = model.limit
    sortdirection = model.sortdirection
    apikey = model.apikey
    ticker = model.ticker
    to = model.to
    from = model.from
    multiplier = model.multiplier
    timespan = model.timespan

    # build up the base string -
    base_url = "$(base)/v$(apiversion)/aggs/ticker/$(ticker)/range/$(multiplier)/$(timespan)/$(from)/$(to)?"

    # what keys are passed as parameters?
    options_dictionary = Dict{String,Any}()
	options_dictionary["adjusted"] = adjusted
	options_dictionary["sort"] = sortdirection
	options_dictionary["limit"] = limit
	options_dictionary["apiKey"] = apikey

    # return -
    return _add_parameters_to_url_query_string(base_url, options_dictionary)
end

function url(base::String, model::PolygonTickerDetailsEndpointModel; 
    apiversion::Int = 3)::String #ycpan

    # get data from the API call data -
    apikey = model.apikey
    ticker = model.ticker
    date   = model.date #ycpan
    
    # build up the base string -
    base_url = "$(base)/v$(apiversion)/reference/tickers/$(ticker)?" #ycpan

    # what keys are passed as parameters?
    options_dictionary = Dict{String,Any}()
    options_dictionary["date"] = date #ycpan
    options_dictionary["apiKey"] = apikey

    # return -
    return _add_parameters_to_url_query_string(base_url, options_dictionary)
end

function url(base::String, model::PolygonMarketHolidaysEndpointModel; #ycpan
    apiversion::Int = 1)::String

    # get data from the API call data - no data
    apikey = model.apikey    

    # build up the base string -
    base_url = "$(base)/v$(apiversion)/marketstatus/upcoming?"

    # what keys are passed as parameters?
    options_dictionary = Dict{String,Any}()
    options_dictionary["apiKey"] = apikey

    # return -
    return _add_parameters_to_url_query_string(base_url, options_dictionary)
end

function url(base::String, model::PolygonExchangesEndpointModel; #ycpan
    apiversion::Int = 3)::String #ycpan

    # get data from the API call data -
    apikey = model.apikey
    asset_class = model.asset_class
    locale   = model.locale #ycpan
    
    # build up the base string -
    base_url = "$(base)/v$(apiversion)/reference/exchanges?"
    
    # what keys are passed as parameters?
    options_dictionary = Dict{String,Any}()
    options_dictionary["asset_class"] = asset_class
    options_dictionary["locale"] = locale
    options_dictionary["apiKey"] = apikey

    # return -
    return _add_parameters_to_url_query_string(base_url, options_dictionary)
end

function url(base::String, model::PolygonStockSplitsEndpointModel; #ycpan
    apiversion::Int = 3)::String

    # get data from the API call data -
    apikey = model.apikey
    ticker = model.ticker
    execution_date = model.execution_date
    reverse_split = model.reverse_split
    order = model.order
    limit = model.limit
    sort = model.sort
    
    # build up the base string -
    base_url = "$(base)/v$(apiversion)/reference/splits?"
    
    # what keys are passed as parameters?
    options_dictionary = Dict{String,Any}()
    options_dictionary["ticker"] = ticker
    options_dictionary["execution_date"] = execution_date
    options_dictionary["reverse_split"] = reverse_split
    options_dictionary["order"] = order
    options_dictionary["limit"] = limit
    options_dictionary["sort"] = sort
    options_dictionary["apiKey"] = apikey
    
    #not all parameters are required, if we have N/A input, we remove it"
    for options ∈ keys(options_dictionary)
        if options_dictionary[options] == "N/A"
            pop!(options_dictionary, options)
        end
    end
            
    # return -
    return _add_parameters_to_url_query_string(base_url, options_dictionary)
end

function url(base::String, model::PolygonMarketStatusEndpointModel; #ycpan
    apiversion::Int = 1)::String

    # get data from the API call data - no data
    apikey = model.apikey    

    # build up the base string -
    base_url = "$(base)/v$(apiversion)/marketstatus/now?"
    
    # what keys are passed as parameters?
    options_dictionary = Dict{String,Any}()
    options_dictionary["apiKey"] = apikey

    # return -
    return _add_parameters_to_url_query_string(base_url, options_dictionary)
end
# -- URL FACTORY METHODS ABOVE HERE --------------------------------------------------- #
