require 'elasticsearch/model'

class Place < ActiveRecord::Base
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
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  # Set up index configuration and mapping
    settings index: {
      number_of_shards:   1,
      number_of_replicas: 0,
      analysis: {
        filter: {
          pos_filter: {
            type:     'kuromoji_part_of_speech',
            stoptags: ['助詞-格助詞-一般', '助詞-終助詞'],
          },
          greek_lowercase_filter: {
            type:     'lowercase',
            language: 'greek',
          },
        },
        tokenizer: {
          kuromoji: {
            type: 'kuromoji_tokenizer'
          },
          ngram_tokenizer: {
            type: 'nGram',
            min_gram: '2',
            max_gram: '3',
            token_chars: ['letter', 'digit']
          }
        },
        analyzer: {
          kuromoji_analyzer: {
            type:      'custom',
            tokenizer: 'kuromoji_tokenizer',
            filter:    ['kuromoji_baseform', 'pos_filter', 'greek_lowercase_filter', 'cjk_width'],
          },
          ngram_analyzer: {
            tokenizer: "ngram_tokenizer"
          }
        }
      }
    } do
      mapping _source: { enabled: true }, 
_all: { enabled: true, analyzer: "kuromoji_analyzer" } do
        indexes :id, type: 'integer', index: 'not_analyzed'
        indexes :name, type: 'string', analyzer: 'kuromoji_analyzer'
        indexes :comment, type: 'string', analyzer: 'kuromoji_analyzer'
        indexes :address, type: 'string', analyzer: 'kuromoji_analyzer'
      end
    end


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
