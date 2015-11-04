class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :name
      t.string :area
      t.string :prefecture
      t.string :address
      t.float :atitude
      t.float :longitude
      t.string :create_user_name
      t.string :category
      t.string :comment

      t.timestamps null: false
    end
  end
end
