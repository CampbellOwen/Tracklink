class RouteWithStop < ActiveRecord::Base
    validates_uniqueness_of :stopID, :scope => :routeID

    def self.save_data_from_json
        stop_data = JSON.parse(File.read('app/script/stops.json'))

        stops = stop_data.map do |stop|
            a = stop['Routes'].split(', ')
            a.size.times{|i| 
                rws = RouteWithStop.new

                stopno = Stop.find_by(StopNo: stop['StopNo'])
                if stopno == nil
                    next
                end
                rws.stopID = stopno.id

                routeno = Line.find_by(RouteNo: a[i])
                if routeno == nil
                    next
                end
                rws.routeID = routeno.id
                rws.save
                rws
            }
        end
    end

end
