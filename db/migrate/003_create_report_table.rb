class CreateReportTable < ActiveRecord::Migration
  def self.up
    create_table "search_reports" do |t|
      t.string :email
      t.text :search_result
    end
    
  end

  def self.down
    drop_table :search_reports
  end
  

end
