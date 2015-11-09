class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
         
  has_many :following_relationships, class_name:  "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :following_users, through: :following_relationships, source: :followed
  has_many :followed_relationships, class_name:  "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followed_users, through: :followed_relationships, source: :follower
             
  has_many :ownerships , foreign_key: "user_id", dependent: :destroy
  has_many :places ,through: :ownerships
  has_many :wants, class_name: "Want", foreign_key: "user_id", dependent: :destroy
  has_many :want_places , through: :wants, source: :place
  has_many :visits, class_name: "Visit", foreign_key: "user_id", dependent: :destroy
  has_many :visit_places , through: :visits, source: :place
    
  # 他のユーザーをフォローする
  def follow(other_user)
    following_relationships.create(followed_id: other_user.id)
  end
  def unfollow(other_user)
    following_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following_users.include?(other_user)
  end
  def visit(ownership)
#    visits.find_or_create_by(place_id: ownership.place_id, photo: ownership.photo, comment: ownership.comment) #katteni user_id hairu? soujanaku, user no have_places to kaishaku?
#     visits.find_or_create_by(place_id: ownership.place_id)
     visit = visits.build(place_id: ownership.place_id, photo: ownership.photo, comment: ownership.comment)  
     # check logic
     if visits.find_by(place_id: ownership.place_id)
     else
       visit.save
     end
     #binding.pry
  end

  def unvisit(place)
    visits.find_by(place_id: place.id).destroy
  end

  def visit?(place)
    visit_places.include?(place)
  end

  def want(ownership)
    wants.find_or_create_by(place_id: ownership.place_id)
  end

  def unwant(place)
    #binding.pry
    wants.find_by(place_id: place.id).destroy
  end

  def want?(place)
    want_places.include?(place)
  end
end
