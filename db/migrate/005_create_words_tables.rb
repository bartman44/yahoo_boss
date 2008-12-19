class CreateWordsTables < ActiveRecord::Migration
  def self.up
    create_table "stop_words" do |t|
      t.string :word
    end
    create_table "dictionaries" do |t|
      t.string :word
    end
    create_table "synonym_words" do |t|
      t.string :word
    end
    create_table "synonyms" do |t|
      t.integer :synonym_id
      t.integer :synonym_2_id
    end
    
  end

  def self.down
    drop_table "stop_words"
    drop_table "dictionaries"
    drop_table "synonym_words"
    drop_table "synonyms"
  end
  

end
