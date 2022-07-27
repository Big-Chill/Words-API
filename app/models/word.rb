class Word < ApplicationRecord
  has_many :definitions
  has_many :examples
  has_many :synonyms
  has_many :antonyms
end
