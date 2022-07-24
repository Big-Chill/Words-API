class Synonym < ApplicationRecord
  belongs_to :word

  def self.fetch_synonym(word)
    synonyms = []
    word.synonyms.all.each do |synonym|
      synonyms.push( { "text":synonym["text"] } )
    end
    return synonyms
  end
end
