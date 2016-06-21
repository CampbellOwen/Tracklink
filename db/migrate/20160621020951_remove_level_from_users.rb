class RemoveLevelFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :level, :string
  end
end
