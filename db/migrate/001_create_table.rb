class CreateTable < ActiveRecord::Migration
  def self.up
    create_table "yahoo_bosses" do |t|
      t.string :key
    end
    
  end

  def self.down
    drop_table :yahoo_bosses
  end
  

end
