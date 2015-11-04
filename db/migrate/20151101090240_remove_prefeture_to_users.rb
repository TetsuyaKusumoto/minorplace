class RemovePrefetureToUsers < ActiveRecord::Migration
  def change
    remove_column :users, :prefeture, :string
  end
end
