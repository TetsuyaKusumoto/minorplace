class RemoveAtitudeToPlaces < ActiveRecord::Migration
  def change
    remove_column :places, :atitude, :float
  end
end
