class AddWheelchairaccessToStops < ActiveRecord::Migration
  def change
      add_column :stops, :WheelchairAccess, :boolean
  end
end
