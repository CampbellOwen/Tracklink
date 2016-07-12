class Line < ActiveRecord::Base
    validates_uniqueness_of :RouteNo, :scope => :Direction
    validates :RouteNo, presence: true
    def self.save_data_from_api
        response = HTTParty.get("http://api.translink.ca/rttiapi/v1/buses?apikey=QUprTm0ALxtTt4npEjl6",
                                :headers => { "Accept" => "application/JSON"});
        line_data = JSON.parse(response.body)
        lines = line_data.map do |line|
            l = Line.new
            l.RouteNo = line['RouteNo']
            l.Direction = line['Direction']
            l.Destination = line['Destination']
            l.save
            l
        end
    end
end
