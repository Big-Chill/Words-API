class Word < ApplicationRecord
  has_many :definitions
  has_many :examples
  has_many :synonyms
  has_many :antonyms

  def self.is_valid_word?(word)
    return self.find_by(word_name: word)
  end
end
