module ApiHelper
    def getDestination(stop, route)
        url = 'http://api.translink.ca/rttiapi/v1/stops/'+stop.StopNo.to_s+'/estimates?apikey=QUprTm0ALxtTt4npEjl6&count=1&routeNo='+route
        response = HTTParty.get(url, :headers => {'Accept' => 'application/json'})
        response_json = JSON.parse(response.body)
        dest = response_json[0]["Schedules"][0]["Destination"]
        return dest
    end

    def getOrigin(stop, route)
        puts stop.Name
    end

    def stopEstimate(stop, route)
        url = 'http://api.translink.ca/rttiapi/v1/stops/'+stop+'/estimates?apikey=QUprTm0ALxtTt4npEjl6&count=1'
        if (route != nil)
            url = url + '&routeNo='+route
        end
        response = HTTParty.get(url, :headers => {"Accept" => 'application/json'})
        estimate_data = JSON.parse(response.body)
        puts estimate_data[0]["Schedules"][0]["ExpectedLeaveTime"]
        return estimate_data[0]["Schedules"][0]["ExpectedLeaveTime"]
    end
end
