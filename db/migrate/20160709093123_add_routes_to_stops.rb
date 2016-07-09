class AddRoutesToStops < ActiveRecord::Migration
  def change
    add_column :stops, :Routes, :string
  end
end
