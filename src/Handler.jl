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

    # before we do anything - check: do we have an error?
    status_flag = request_body_dictionary["status"]
    if (status_flag == "NOT_FOUND" || status_flag == "ERROR") #ycpan
        return _polygon_error_handler(request_body_dictionary)
    end
    
    # initialize - #ycpan
    header_dictionary = Dict{String,Any}()
    df = DataFrame(

        ticker = String[],
        name = String[],
        market = String[],
        locale = String[],
        primary_exchange = String[],
        type = String[],
        active = Bool[],
        currency_name = String[],
        cik = String[],
        composite_figi = String[],
        share_class_figi = String[],
        market_cap = Int[],
        phone_number = String[],
        address = Dict{String, Any}(),
        #description = String[],
        sic_code = String[],
        sic_description = String[],
        ticker_root = String[],
        #homepage_url = String[],
        #total_employees = Int[],
        list_date = Date[],
        #branding = Dict{String, Any}(),
        share_class_shares_outstanding = Int[],
        weighted_shares_outstanding = Int[]
    );
    
    # fill in the header dictionary -
    header_keys = [
            "status", "request_id"
    ];
    for key ∈ header_keys
        header_dictionary[key] = request_body_dictionary[key]
    end

    # populate the results DataFrame -#ycpan
    results_array = request_body_dictionary["results"]

    # build a results tuple - #ycpan
    result_tuple = (

                ticker = results_array["ticker"],
                name = results_array["name"],
                market = results_array["market"],
                locale = results_array["locale"],
                primary_exchange = results_array["primary_exchange"],
                type = results_array["type"],
                active = results_array["active"],
                currency_name = results_array["currency_name"],
                cik = results_array["cik"],
                composite_figi = results_array["composite_figi"],
                share_class_figi = results_array["share_class_figi"],
                market_cap = results_array["market_cap"],
                phone_number = results_array["phone_number"],
                address = results_array["address"],
                #description = results_array["description"],
                sic_code = results_array["sic_code"],
                sic_description = results_array["sic_description"],
                ticker_root = results_array["ticker_root"],
                #homepage_url = results_array["homepage_url"],
                #total_employees = results_array["total_employees"],
                list_date = Date(results_array["list_date"]),
                #branding = results_array["branding"],
                share_class_shares_outstanding = results_array["share_class_shares_outstanding"],
                weighted_shares_outstanding = results_array["weighted_shares_outstanding"]
            )
    # push that tuple into the df -
    push!(df, result_tuple)
    

    # return -
    return (header_dictionary, df)
end

function _process_market_holidays_call_response(body::String) #ycpan

    # convert to JSON -
    request_body_dictionary = JSON.parse(body)

    
# initialize -
    header_dictionary = Dict{String,Any}()
    df = DataFrame(

        exchange = String[],
        name = String[],
        date = Date[],
        status = String[]
    );

    # populate the results DataFrame -
    results_array = request_body_dictionary
    for result_dictionary ∈ results_array

        # build a results tuple -
        result_tuple = (

            exchange = result_dictionary["exchange"],
            name = result_dictionary["name"],
            date = Date(result_dictionary["date"]),
            status = result_dictionary["status"]
        )
    
        # push that tuple into the df -
        push!(df, result_tuple)
    end
    
    # return -
    return (header_dictionary, df)
end

function _process_exchanges_call_response(body::String) #ycpan

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

        id = Int[],
        type = String[],
        asset_class = String[],
        locale = String[],
        name = String[],
        acronym = String[],
        mic = String[],
        operating_mic = String[],
        participant_id = String[],
        url = String[]

    );
    
    # fill in the header dictionary -
    header_keys = [
            "status", "request_id", "count"
    ];
    
    # check - do we have a count (if not resturn zero)
    results_count = get!(request_body_dictionary, "count", 0)
    
    # if no result we return nothing
    if (results_count == 0) # we have no results ...
        # return the header and nothing -
        return (header_dictionary, nothing)
    end
    
    for key ∈ header_keys
        header_dictionary[key] = request_body_dictionary[key]
    end

    # populate the results DataFrame -
    results_array = request_body_dictionary["results"]
    for result_dictionary ∈ results_array
        # set some defaults in case missing fields -
        get!(result_dictionary, "id", 0)
        get!(result_dictionary, "type", "N/A")
        get!(result_dictionary, "asset_class", "N/A")
        get!(result_dictionary, "locale", "N/A")
        get!(result_dictionary, "name", "N/A")
        get!(result_dictionary, "acronym", "N/A")
        get!(result_dictionary, "mic", "N/A")
        get!(result_dictionary, "operating_mic", "N/A")
        get!(result_dictionary, "participant_id", "N/A")
        get!(result_dictionary, "url", "N/A")

        result_tuple = (

                    id = result_dictionary["id"],
                    type = result_dictionary["type"],
                    asset_class = result_dictionary["asset_class"],
                    locale = result_dictionary["locale"],
                    name = result_dictionary["name"],
                    acronym = result_dictionary["acronym"],
                    mic = result_dictionary["mic"],
                    operating_mic = result_dictionary["operating_mic"],
                    participant_id = result_dictionary["participant_id"],
                    url = result_dictionary["url"]
                )

        push!(df, result_tuple)
    end
    
    # return -
    return (header_dictionary, df)
end

function _process_stock_splits_call_response(body::String) #ycpan

    # convert to JSON -
    request_body_dictionary = JSON.parse(body)

    
    # initialize -
    header_dictionary = Dict{String,Any}()
    df = DataFrame(

        execution_date = Date[],
        split_from = Int[],
        split_to = Int[],
        ticker = String[]

    );
    
    # fill in the header dictionary -
    header_keys = [
            "status", "request_id"
    ];
    
    for key ∈ header_keys
        header_dictionary[key] = request_body_dictionary[key]
    end

    # if no result we return nothing
    if (request_body_dictionary["results"] == Any[]) # we have no results ...
        # return the header and nothing -
        return (header_dictionary, nothing)
    end

    # populate the results DataFrame -
    results_array = request_body_dictionary["results"]
    for result_dictionary ∈ results_array

        result_tuple = (

                    execution_date = Date(result_dictionary["execution_date"]),
                    split_from = result_dictionary["split_from"],
                    split_to = result_dictionary["split_to"],
                    ticker = result_dictionary["ticker"] 
                )

        push!(df, result_tuple)
    end
    
    # return -
    return (header_dictionary, df)
end

function _process_market_status_call_response(body::String) #ycpan

    # convert to JSON -
    request_body_dictionary = JSON.parse(body)
    
    #initialize -
    header_dictionary = Dict{String,Any}()
    df = DataFrame(

    market = String[],
    earlyHours = Bool[],
    afterHours = Bool[],
    serverTime = String[],
    nyse  = String[],
    nasdaq  = String[],
    fx  = String[],
    crypto  = String[]
    );

    # populate the results DataFrame -
    results_array = request_body_dictionary
    
    # build a results tuple -
    result_tuple = (
    
        market = results_array["market"],
        earlyHours = results_array["earlyHours"],
        afterHours = results_array["afterHours"],
        serverTime = results_array["serverTime"],
        nyse = results_array["exchanges"]["nyse"],
        nasdaq = results_array["exchanges"]["nasdaq"],
        fx = results_array["currencies"]["fx"],
        crypto = results_array["currencies"]["crypto"]
        )
    
    # push that tuple into the df -
    push!(df, result_tuple)
    
    # return -
    return (header_dictionary, df)
end

function _process_dividends_call_response(body::String) #ycpan

    # convert to JSON -
    request_body_dictionary = JSON.parse(body)

    
    # before we do anything - check: do we have an error? can be due to stick or date
    status_flag = request_body_dictionary["status"]
    if (status_flag == "NOT_FOUND" || status_flag == "ERROR")
        return _polygon_error_handler(request_body_dictionary)
    end

    #initialize -
    header_dictionary = Dict{String,Any}()
    df = DataFrame(

            cash_amount = Float64[],
            declaration_date = Date[],
            dividend_type = String[],
            ex_dividend_date = Date[],
            frequency = Int[],
            pay_date = Date[],
            record_date = Date[],
            ticker =String[]
        )

    # fill in the header dictionary -
    header_keys = [
                "status", "request_id","next_url"
        ];

    #fill in next_url if no value
    get!(request_body_dictionary,"next_url","N/A")

    # if no results we return nothing
    if (request_body_dictionary["results"] == Any[]) # we have no results ...
        # return the header and nothing -
        return (header_dictionary, nothing)
    end

    for key ∈ header_keys
        header_dictionary[key] = request_body_dictionary[key]
    end

    results_array = request_body_dictionary["results"]
    for result_dictionary ∈ results_array

        result_tuple = (

                    cash_amount = result_dictionary["cash_amount"],
                    declaration_date = Date(result_dictionary["declaration_date"]),
                    dividend_type = result_dictionary["dividend_type"],
                    ex_dividend_date = Date(result_dictionary["ex_dividend_date"]),
                    frequency = result_dictionary["frequency"],
                    pay_date = Date(result_dictionary["pay_date"]),
                    record_date = Date(result_dictionary["record_date"]),
                    ticker = result_dictionary["ticker"],

                )

        push!(df, result_tuple)
    end

    # return -
    return (header_dictionary, df)
end
