class Stop < ActiveRecord::Base
    validates_uniqueness_of :StopNo
    validates :Latitude, numericality: {only_decimal: true}
    validates :Longitude, numericality: {only_decimal: true}
    validates :StopNo, numericality: { only_integer: true}
    validates :StopNo, presence: true
    validates :Routes, presence: true

    def self.save_data_from_api
        stop_data = JSON.parse(File.read('app/script/stops.json'))

        stops = stop_data.map do |stop|
            s = Stop.new
            s.Name      = stop['Name']
            s.StopNo    = stop['StopNo']
            s.Latitude  = stop['Latitude']
            s.Longitude = stop['Longitude']
            s.City      = stop['City']
            s.AtStreet  = stop['AtStreet']
            s.OnStreet  = stop['OnStreet']
            s.WheelchairAccess = stop['WheelchairAccess'] == 1 ? true : false
            routes      = stop['Routes']
            if routes != nil and routes != " "
                s.Routes = routes
            end
            s.save
            s
        end
    end
    def self.update_data_from_api
        stop_data = JSON.parse(File.read('app/script/stops.json'))

        stops = stop_data.map do |stop|
            s = Stop.find_by("StopNo" => stop['StopNo'])
            s.Name      = stop['Name']
            s.StopNo    = stop['StopNo']
            s.Latitude  = stop['Latitude']
            s.Longitude = stop['Longitude']
            s.City      = stop['City']
            s.AtStreet  = stop['AtStreet']
            s.OnStreet  = stop['OnStreet']
            s.WheelchairAccess = stop['WheelchairAccess'] == 1 ? true : false
            routes      = stop['Routes']
            if routes != nil and routes != " "
                s.Routes = routes
            end
            s.save
            s
        end
    end
end
