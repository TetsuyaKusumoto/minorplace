class Ownership < ActiveRecord::Base
  belongs_to :user, class_name: "User"
  belongs_to :place, class_name: "Place"
  has_attached_file :photo, styles: { medium: "300x300>", thumb: "100x100>" }
  validates_attachment :photo, less_than: 5.megabytes, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }, message: 'ファイル形式が不正です'

end
