class CreateExamples < ActiveRecord::Migration[7.0]
  def change
    create_table :examples do |t|
      t.string :text
      t.belongs_to :word, index: true,foreign_key: true
      t.timestamps
    end
  end
end
