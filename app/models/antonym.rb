class Antonym < ApplicationRecord
  belongs_to :word

  def self.fetch_antonym(word)
    antonyms = []
    word.antonyms.all.each do |antonym|
      antonyms.push( { "text":antonym["text"] } )
    end
    return antonyms
  end

end
