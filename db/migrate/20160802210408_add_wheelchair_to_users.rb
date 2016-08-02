class AddWheelchairToUsers < ActiveRecord::Migration
  def change
      add_column :users, :wheelchair, :boolean
  end
end
