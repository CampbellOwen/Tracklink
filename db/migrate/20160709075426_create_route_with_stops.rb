class CreateRouteWithStops < ActiveRecord::Migration
  def change
    create_table :route_with_stops do |t|
      t.integer :stopID
      t.integer :routeID

      t.timestamps null: false
    end
  end
end
