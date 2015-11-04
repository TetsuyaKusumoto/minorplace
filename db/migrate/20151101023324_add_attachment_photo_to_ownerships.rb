class AddAttachmentPhotoToOwnerships < ActiveRecord::Migration
  def self.up
    change_table :ownerships do |t|
      t.attachment :photo
    end
  end

  def self.down
    remove_attachment :ownerships, :photo
  end
end
