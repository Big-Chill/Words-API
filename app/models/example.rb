class Example < ApplicationRecord
  belongs_to :word

  def self.fetch_example(word)
    examples = []
    word.examples.all.each do |example|
      examples.push( { "text":example["text"] } )
    end
    return examples
  end
end
