function _http_get_call_with_url(url::String)::Some

    try

        # should we check if this string is formatted as a URL?
        if (occursin("https://", url) == false)
            throw(ArgumentError("url $(url) is not properly formatted"))
        end

        # ok, so we are going to make a HTTP GET call with the URL that was passed in -
        # we want to handle the errors on our own, so do NOT have HTTP.j throw an excpetion -
        response = HTTP.request("GET", url; status_exception = false)

        # return the body -
        return Some(String(response.body))
    catch error

        # get the original error message -
        error_message = sprint(showerror, error, catch_backtrace())
        vl_error_obj = ErrorException(error_message)

        # Package the error -
        return Some(vl_error_obj)
    end
end

function _process_polygon_response(model::Type{T}, 
    response::String)::Tuple where T<:AbstractPolygonEndpointModel

    # which handler should we call?
    if (model == PolygonAggregatesEndpointModel)
        return _process_aggregates_polygon_call_response(response)
    elseif (model == PolygonOptionsContractReferenceEndpoint)
        return _process_options_reference_call_response(response)
    elseif (model == PolygonPreviousCloseEndpointModel)
        return _process_previous_close_polygon_call_response(response)
    end

    # default -
    return nothing
end

function api(model::Type{T}, complete_url_string::String;
    handler::Function = _process_polygon_response)::Tuple where T<:AbstractPolygonEndpointModel

    # execute -
    result_string = _http_get_call_with_url(complete_url_string) |> check

    # process and return -
    return handler(model, result_string)
end