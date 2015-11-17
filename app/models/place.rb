require 'elasticsearch/model'

class Place < ActiveRecord::Base
  include Searchable
  validates :name, presence: true, length: { maximum: 140 }
  has_attached_file :photo, styles: { medium: "300x300>", thumb: "100x100>" }
  validates_attachment :photo, less_than: 5.megabytes, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }, message: 'ファイル形式が不正です'
  geocoded_by :address
  after_validation :geocode
  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode

  has_many :ownerships  , foreign_key: "place_id" , dependent: :destroy
  has_many :users , through: :ownerships
  has_many :wants, class_name: "Want", foreign_key: "place_id", dependent: :destroy
  has_many :want_users , through: :wants, source: :user
  has_many :visits, class_name: "Visit", foreign_key: "place_id", dependent: :destroy
  has_many :visit_users , through: :visits, source: :user
#  def self.search(search) #self.でクラスメソッドとしている
#    if search # Controllerから渡されたパラメータが!= nilの場合は、titleカラムを部分一致検索
#      Place.where(['name LIKE ?', "%#{search}%"])
#    else
#      Place.all #全て表示。
#    end
#  end
#  include Elasticsearch::Model
#  include Elasticsearch::Model::Callbacks


  def want_level
      count = Ownership.where(type: "want", place_id: self.id).count
      if count > 10      
        return "マイナーだけど大人気！"
      elsif count > 5
        return "ちょっとマイナー"
      else
        return "まだまだマイナー"
      end
  end
  def visit_level
      count = Ownership.where(type: "visit", place_id: self.id).count
      if count > 10
        return "みなさんのおかげでメジャーになれました！"
      elsif count > 5
        return "ちょっと人気出てきたかも？"
      else
        return "まだまだマイナー"
      end
  end
  def self.elasticSearch(search)
    if search
      request =  Place.search(search)
      request.records.to_a
    else
      Place.all # show all 
    end
  end
end
