function _polygon_error_handler(request_body_dictionary::Dict{String, Any})::Tuple

    # initialize -
    error_response_dictionary = Dict{String,Any}()
    
    # what are my error keys?
    error_keys = [
        "status", "error", "request_id"
    ]
    for key ∈ error_keys
        error_response_dictionary[key] = request_body_dictionary[key]
    end

    # return -
    return (error_response_dictionary, nothing)
end



function _process_previous_close_polygon_call_response(body::String)

    # convert to JSON -
    request_body_dictionary = JSON.parse(body)

    # before we do anything - check: do we have an error?
    status_flag = request_body_dictionary["status"]
    if (status_flag == "ERROR")
        return _polygon_error_handler(request_body_dictionary)
    end

    # initialize -
    header_dictionary = Dict{String,Any}()
    df = DataFrame(

        ticker=String[],
        volume=Float64[],
        volume_weighted_average_price=Float64[],
        open=Float64[],
        close=Float64[],
        high=Float64[],
        low=Float64[],
        timestamp=Date[],
        number_of_transactions=Int[]
    )

    # fill in the header dictionary -
    header_keys = [
        "ticker", "queryCount", "adjusted", "status", "request_id", "count"
    ]

    # check - do we have a count (if not resturn zero)
    get!(request_body_dictionary, "count", 0)

    for key ∈ header_keys
        header_dictionary[key] = request_body_dictionary[key]
    end

    # check - do we have a resultsCount field?
    results_count = get!(request_body_dictionary, "resultsCount", 0)
    if (results_count == 0) # we have no results ...
        # return the header and nothing -
        return (header_dictionary, nothing)
    end

    # populate the results DataFrame -
    results_array = request_body_dictionary["results"]
    for result_dictionary ∈ results_array
        
        # build a results tuple -
        result_tuple = (

            ticker = result_dictionary["T"],
            volume = result_dictionary["v"],
            volume_weighted_average_price = result_dictionary["vw"],
            open = result_dictionary["o"],
            close = result_dictionary["c"],
            high = result_dictionary["h"],
            low = result_dictionary["l"],
            timestamp = unix2datetime(result_dictionary["t"]*(1/1000)),
            number_of_transactions = result_dictionary["n"]
        )
    
        # push that tuple into the df -
        push!(df, result_tuple)
    end

    # return -
    return (header_dictionary, df)
end

function _process_aggregates_polygon_call_response(body::String)

    # convert to JSON -
    request_body_dictionary = JSON.parse(body)

    # before we do anything - check: do we have an error?
    status_flag = request_body_dictionary["status"]
    if (status_flag == "ERROR")
        return _polygon_error_handler(request_body_dictionary)
    end

    # initialize -
    header_dictionary = Dict{String,Any}()
    df = DataFrame(

        volume=Float64[],
        volume_weighted_average_price=Float64[],
        open=Float64[],
        close=Float64[],
        high=Float64[],
        low=Float64[],
        timestamp=Date[],
        number_of_transactions=Int[]
    )

    # fill in the header dictionary -
    header_keys = [
        "ticker", "queryCount", "adjusted", "status", "request_id", "count"
    ]

    # check - do we have a count (if not resturn zero)
    get!(request_body_dictionary, "count", 0)

    for key ∈ header_keys
        header_dictionary[key] = request_body_dictionary[key]
    end

    # check - do we have a resultsCount field?
    results_count = get!(request_body_dictionary, "resultsCount", 0)
    if (results_count == 0) # we have no results ...
        # return the header and nothing -
        return (header_dictionary, nothing)
    end

    # populate the results DataFrame -
    results_array = request_body_dictionary["results"]
    for result_dictionary ∈ results_array
        
        # build a results tuple -
        result_tuple = (

            volume = result_dictionary["v"],
            volume_weighted_average_price = result_dictionary["vw"],
            open = result_dictionary["o"],
            close = result_dictionary["c"],
            high = result_dictionary["h"],
            low = result_dictionary["l"],
            timestamp = unix2datetime(result_dictionary["t"]*(1/1000)),
            number_of_transactions = result_dictionary["n"]
        )
    
        # push that tuple into the df -
        push!(df, result_tuple)
    end

    # return -
    return (header_dictionary, df)
end

function _process_options_reference_call_response(body::String)

    # convert to JSON -
    request_body_dictionary = JSON.parse(body)

    # before we do anything - check: do we have an error?
    status_flag = request_body_dictionary["status"]
    if (status_flag == "ERROR")
        return _polygon_error_handler(request_body_dictionary)
    end

    # initialize -
    header_dictionary = Dict{String,Any}()
    df = DataFrame(

        cfi=String[],
        contract_type=String[],
        exercise_style=String[],
        expiration_date=Date[],
        primary_exchange=String[],
        shares_per_contract=Int64[],
        strike_price=Float64[],
        ticker = String[],
        underlying_ticker = String[]
    )

    # fill in the header dictionary -
    header_keys = [
        "status", "request_id", "count", "next_url"
    ]
    for key ∈ header_keys
        header_dictionary[key] = request_body_dictionary[key]
    end

    # populate the results DataFrame -
    results_array = request_body_dictionary["results"]
    for result_dictionary ∈ results_array
        
        # build a results tuple -
        result_tuple = (

            cfi = result_dictionary["cfi"],
            contract_type = result_dictionary["contract_type"],
            exercise_style = result_dictionary["exercise_style"],
            expiration_date = Date(result_dictionary["expiration_date"]),
            primary_exchange = result_dictionary["primary_exchange"],
            shares_per_contract = result_dictionary["shares_per_contract"],
            strike_price = result_dictionary["strike_price"],
            ticker = result_dictionary["ticker"],
            underlying_ticker = result_dictionary["underlying_ticker"]
        )
    
        # push that tuple into the df -
        push!(df, result_tuple)
    end

    # return -
    return (header_dictionary, df)
end
