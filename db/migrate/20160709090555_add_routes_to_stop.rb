class AddRoutesToStop < ActiveRecord::Migration
  def change
      add_column :lines, :Routes, :string
  end
end
