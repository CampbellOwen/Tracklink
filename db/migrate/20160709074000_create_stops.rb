class CreateStops < ActiveRecord::Migration
  def change
    create_table :stops do |t|
      t.string :Name
      t.integer :StopNo
      t.decimal :Latitude
      t.decimal :Longitude
      t.string :City
      t.string :AtStreet
      t.string :OnStreet

      t.timestamps null: false
    end
  end
end
