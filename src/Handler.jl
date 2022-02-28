function _polygon_error_handler(request_body_dictionary::Dict{String, Any})::Tuple

    # initialize -
    error_response_dictionary = Dict{String,Any}()
    
    # what are my error keys?
    error_keys = keys(request_body_dictionary)
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
        timestamp=DateTime[],
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
        timestamp=DateTime[],
        number_of_transactions=Int[]
    )

    # fill in the header dictionary -
    header_keys = [
        "ticker", "queryCount", "adjusted", "status", "request_id", "count"
    ]

    # check - do we have a count (if not resturn zero)
    get!(request_body_dictionary, "count", 0)
    get!(request_body_dictionary, "ticker", "N/A")

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
        
        # set some defaults in case missing fields -
        get!(result_dictionary, "vw", 0.0)
        get!(result_dictionary, "n", 0)

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

function _process_daily_open_close_call_response(body::String)

    # convert to JSON -
    request_body_dictionary = JSON.parse(body)

    # before we do anything - check: do we have an error?
    status_flag = request_body_dictionary["status"]
    if (status_flag == "ERROR" || status_flag == "NOT_FOUND")
        return _polygon_error_handler(request_body_dictionary)
    end

    # initialize -
    header_dictionary = Dict{String,Any}()
    df = DataFrame(

        ticker=String[],
        volume=Float64[],
        open=Float64[],
        close=Float64[],
        high=Float64[],
        low=Float64[],
        from=Date[],
        afterHours=Float64[],
        preMarket=Float64[]
    )

    header_keys = [
        "status"
    ]
    for key ∈ header_keys
        header_dictionary[key] = request_body_dictionary[key]
    end

    # build a results tuple -
    result_tuple = (

        volume = request_body_dictionary["volume"],
        open = request_body_dictionary["open"],
        close = request_body_dictionary["close"],
        high = request_body_dictionary["high"],
        low = request_body_dictionary["low"],
        from = Date(request_body_dictionary["from"]),
        ticker = request_body_dictionary["symbol"],
        afterHours = request_body_dictionary["afterHours"],
        preMarket = request_body_dictionary["preMarket"]
    )

    # push that tuple into the df -
    push!(df, result_tuple)

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

function _process_ticker_news_call_response(body::String)

    # convert to JSON -
    request_body_dictionary = JSON.parse(body)

    # before we do anything - check: do we have an error?
    status_flag = request_body_dictionary["status"]
    if (status_flag == "ERROR")
        return _polygon_error_handler(request_body_dictionary)
    end

    # initialize -
    header_dictionary = Dict{String,Any}()
    df = DataFrame();

    # fill in the header dictionary -
    header_keys = [
        "status", "request_id", "count", "next_url"
    ]
    for key ∈ header_keys
        header_dictionary[key] = request_body_dictionary[key]
    end

    # return -
    return (header_dictionary, df)
end

function _process_ticker_details_call_response(body::String)

    # convert to JSON -
    request_body_dictionary = JSON.parse(body)

    # before we do anything - check: do we have an error? can be due to stick or date
    status_flag = request_body_dictionary["status"]
    if (status_flag == "ERROR" || status_flag == "NOT_FOUND")
        return _polygon_error_handler(request_body_dictionary)
    end
    
    # initialize -
    header_dictionary = Dict{String,Any}()
    df = DataFrame(

        ticker = String[],
        name = String[],
        market = String[],
        locale = String[],
        primary_exchange = String[],
        type = String[],
        #active = Bool[], #watch out whether it works
        #currency_name = String[],
        #cik = String[],
        #composite_figi = String[],
        #share_class_figi = String[],
        #market_cap = Int[],
        #phone_number = String[],
        #address = Array{Array{String,1},1}(), #not sure curly bracket's type
        #description = String[],
        #sic_code = String[],
        #sic_description = String[],
        #ticker_root = String[],
        #homepage_url = String[],
        #total_employees = Int[],
        #list_date = Date[],
        #branding = Array{Array{String,1},1}(), #not sure curly bracket's type
        #share_class_shares_outstanding = Int[],
        #weighted_shares_outstanding = Int[]
    );
    
    # fill in the header dictionary -
    header_keys = [
            "status", "request_id"
    ];
    for key ∈ header_keys
        header_dictionary[key] = request_body_dictionary[key]
    end

    # populate the results DataFrame -
    results_array = request_body_dictionary["results"]
    for result_dictionary ∈ results_array

        # build a results tuple -
        result_tuple = (

            ticker = result_dictionary["ticker"],
            name = result_dictionary["name"],
            market = result_dictionary["market"],
            locale = result_dictionary["locale"],
            primary_exchange = result_dictionary["primary_exchange"],
            type = result_dictionary["type"],
            #active = result_dictionary["active"],
            #currency_name = result_dictionary["currency_name"],
            #cik = result_dictionary["cik"],
            #composite_figi = result_dictionary["composite_figi"],
            #share_class_figi = result_dictionary["share_class_figi"],
            #market_cap = result_dictionary["market_cap"],
            #phone_number = result_dictionary["phone_number"],
            #address = result_dictionary["address"],
            #description = result_dictionary["description"],
            #sic_code = result_dictionary["sic_code"],
            #sic_description = result_dictionary["sic_description"],
            #ticker_root = result_dictionary["ticker_root"],
            #homepage_url = result_dictionary["homepage_url"],
            #total_employees = result_dictionary["total_employees"],
            #list_date = Date(result_dictionary["list_date"]),
            #branding = result_dictionary["branding"],
            #share_class_shares_outstanding = result_dictionary["share_class_shares_outstanding"],
            #weighted_shares_outstanding = result_dictionary["weighted_shares_outstanding"]
        )

    # push that tuple into the df -
        push!(df, result_tuple)
    end

    # return -
    return (header_dictionary, df)
end
