class AddColumns < ActiveRecord::Migration
  def self.up
    add_column :yahoo_bosses, :modified_strings, :bool
  end

  def self.down
    drop_table :yahoo_bosses, :modified_strings
  end
  

end
