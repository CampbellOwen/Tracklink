module ApiHelper
    def getDestination(stop, route)
        url = 'http://api.translink.ca/rttiapi/v1/stops/'+stop.StopNo.to_s+'/estimates?apikey=QUprTm0ALxtTt4npEjl6&count=1&routeNo='+route
        response = HTTParty.get(url, :headers => {'Accept' => 'application/json'})
        response_json = JSON.parse(response.body)
        begin
            dest = response_json[0]["Schedules"][0]["Destination"]
            return dest
        rescue
            return "N/A"
        end
    end

    def getStops (lat, long)

        url = "http://api.translink.ca/rttiapi/v1/stops?apikey=QUprTm0ALxtTt4npEjl6&lat=" + lat + "&long=" + long; 
        response = HTTParty.get(url, :headers => {'Accept' => 'application/JSON'})
        stops_data = JSON.parse(response.body)
        return stops_data

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
        begin
            return estimate_data[0]["Schedules"][0]["ExpectedLeaveTime"].split(' ')[0]
        rescue
            return "N/A"
        end
    end
end
