class Ownership < ActiveRecord::Base
  belongs_to :user, class_name: "User"
  belongs_to :place, class_name: "Place"
end
