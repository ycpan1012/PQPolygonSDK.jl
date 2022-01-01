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