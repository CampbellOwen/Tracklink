class CreateLines < ActiveRecord::Migration
  def change
    create_table :lines do |t|
      t.string :RouteNo
      t.string :Direction
      t.string :Destination

      t.timestamps null: false
    end
  end
end
