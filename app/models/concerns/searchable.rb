require 'active_support/concern'
module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks
    # Customize the index name
    index_name "place"

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

  end

  module ClassMethods
    def create_index!(options={})
      client = __elasticsearch__.client
      client.indices.delete index: "place" rescue nil if options[:force]
      client.indices.create index: "place",
      body: {
        settings: settings.to_hash,
        mappings: mappings.to_hash
      }
    end
  end
end
