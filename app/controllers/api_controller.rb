class ApiController < ApplicationController
    include ApiHelper
    require 'json'
    respond_to :json, :html
    
    def kmz
        if (params[:stop] == nil || params[:route] == nil)
                respond_with("404")
                return
        end

        puts "Passed nil check"

        url = "http://api.translink.ca/rttiapi/v1/routes?apikey=QUprTm0ALxtTt4npEjl6&stopNo=" + params[:stop]
        response = HTTParty.get(url, :headers => {"Accept" => "application/json"})
        response_json = JSON.parse(response.body)
        puts url
        puts response_json

        begin
            response_json.each do |line|
                if (line["RouteNo"].to_i == params[:route].to_i)

                    puts line["Patterns"][0]["RouteMap"]["Href"]
                    response_arr = []
                    response_arr << line["Patterns"][0]["RouteMap"]["Href"]
                    respond_with(JSON.generate(response_arr))
                    return
                end
            end
            respond_with("404")
            return
        rescue
            respond_with("404")
            return
        end
    end

    def getCoor
        if (params[:stop] == nil)
            respond_with("404")
            return
        end

        stop = Stop.find_by(StopNo: params[:stop])

        lat_long = {
            :lat  => stop.Latitude.to_s,
            :long => stop.Longitude.to_s
        }
        respond_with(JSON.generate(lat_long));
    end

    def location
        if (params[:lat] == nil || params[:long] == nil)
            respond_with("404")
            return
        end

        return_info = []
        routesDone = []
        justRoutes = []

        stops = getStops(params[:lat], params[:long])

        if (stops[0] == nil)
            respond_with("404")
            return
        end

        stopNumbers = []
        stopRouteHash = {}

        stops.each do |stop|
            stopNumbers << stop["StopNo"].to_i
            stopRouteHash[stop["StopNo"].to_i] = stop["Routes"].split(", ")
        end

        stopdbs = Stop.where(StopNo: stopNumbers)


        stopdbs.each do |stopdb|

            dest, time, expected_countdown, schedule_status = getDestinationAndEstimate(stopdb.StopNo.to_s)

            stopRouteHash[stopdb.StopNo].each do |route|
                if (route == nil)
                    next
                end
                if (justRoutes.count(route) >= 2)
                    next
                end

                if (dest[route] == nil or (route + dest[route]).in?routesDone or dest[route] == nil or dest[route] == "N/A")
                    next
                end

                routesDone << (route+dest[route])
                justRoutes << route

                routeHash = {}
                routeHash.store(:id, stopdb.id)
                routeHash.store(:Name, stopdb.Name)
                routeHash.store(:StopNo, stopdb.StopNo)
                routeHash.store(:Latitude, stopdb.Latitude)
                routeHash.store(:Longitude, stopdb.Longitude)
                routeHash.store(:City, stopdb.City)
                routeHash.store(:AtStreet, stopdb.AtStreet)
                routeHash.store(:OnStreet, stopdb.OnStreet)
                routeHash.store(:Route, route)
                routeHash.store(:Destination, dest[route])
                routeHash.store(:NextBus, time[route])
                routeHash.store(:ExpectedCountdown, expected_countdown[route])
                routeHash.store(:ScheduleStatus, schedule_status[route])

                return_info << routeHash
            end
        end


        


        
        sorted = return_info.sort_by { |route| route[:Route] }

        response = JSON.generate(sorted)

        respond_with(response)
        return

    end

    def stop
        @stop = Stop.find_by(StopNo: params[:StonNo])
        if (params[:lat] != nil && params[:long] != nil)
            response = getStops(params[:lat], params[:long])
            respond_with(response)
        elsif (params[:RouteNo] != nil)
            if (@stop == nil)
                    return
            end 
            my_hash = {
                :id             => @stop.id,
                :Name           => @stop.Name,
                :StopNo         => @stop.StopNo,
                :Latitude       => @stop.Latitude,
                :Longitude      => @stop.Longitude,
                :City           => @stop.City,
                :AtStreet       => @stop.AtStreet,
                :OnStreet       => @stop.OnStreet,
                :Route          => params[:RouteNo],
                :Destination    => getDestination(@stop.StopNo, params[:RouteNo]),
                :NextBus        => stopEstimate(@stop.StopNo.to_s, params[:RouteNo])
            }
            response = JSON.generate(my_hash)
            respond_with(response)
        else
            respond_with(@stop)
        end
    end
    def line
        @line = Line.where(:RouteNo => params[:RouteNo])
        respond_with(@line)
    end
    
    def estimate
        #Requires StopNo and RouteNo parameters
        time_hash = {:time =>stopEstimate(params[:StopNo], params[:RouteNo])}
        response = JSON.generate(time_hash)
        respond_with(response)
    end

end
