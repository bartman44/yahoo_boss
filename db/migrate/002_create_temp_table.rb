class CreateTempTable < ActiveRecord::Migration
  def self.up
    create_table "daily_queries" do |t|
      t.string :query
      t.string :ip
    end
    
  end

  def self.down
    drop_table :daily_queries
  end
  

end
