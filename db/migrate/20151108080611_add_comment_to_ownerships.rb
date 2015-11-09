class AddCommentToOwnerships < ActiveRecord::Migration
  def change
    add_column :ownerships, :comment, :string
  end
end
