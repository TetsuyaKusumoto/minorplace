class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :nickname
      t.string :area
      t.string :prefeture
      t.string :address
      t.float :latitude
      t.float :longitude
      t.string :email
      t.string :description
      t.string :password_digest

      t.timestamps null: false
      t.index :email, unique: true
    end
  end
end
