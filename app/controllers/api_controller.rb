class ApiController < ApplicationController
    include ApiHelper
    require 'json'
    respond_to :json, :html
    
    def test
        respond_with(stopEstimate(params[:StopNo], params[:RouteNo]))
    end
    def stop
        @stop = Stop.find_by(StopNo: params[:StopNo])
        if (params[:lat] != nil && params[:long] != nil)
            response = getStops(params[:lat], params[:long])
            respond_with(response)
        elsif (params[:RouteNo] != nil)
            puts "DEBUG: CRASH BEFORE?"
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
                :Destination    => getDestination(@stop, params[:RouteNo]),
                :NextBus        => stopEstimate(@stop.StopNo.to_s, params[:RouteNo])
            }
            puts "DEBUG: CRASH AFTER?"
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
