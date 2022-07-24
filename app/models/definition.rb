class Definition < ApplicationRecord
  belongs_to :word

  def self.fetch_definition(word)
    definitions = []
    word.definitions.all.each do |definition|
      definitions.push( { "text":definition["text"] } )
    end
    return definitions
  end
end
