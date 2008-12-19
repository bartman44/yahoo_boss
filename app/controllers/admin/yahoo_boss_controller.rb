class Admin::YahooBossController < ApplicationController
  
  def index
    @yahoo_boss = YahooBoss.find(:first)
  end
  
  def create
    @yahoo_boss = YahooBoss.new(params[:yahoo_boss])
    if @yahoo_boss.save
      redirect_to "/admin/yahoo_boss"
    end
  end
  
  def update
    @yahoo_boss = YahooBoss.find(:first)
    @yahoo_boss.update_attributes(params[:yahoo_boss])
    if @yahoo_boss.save
      redirect_to "/admin/yahoo_boss"
    end
  end
  
  def tags
    
  end
  
  def modify_strings
    @daily_words = DailyQuery.find(:all)
    
  end
  
  def save_words
    table = params[:actions].camelize.singularize.constantize
    t = table.new()
    #t.word = DailyQuery.find(:first, :conditions=>"")
    #for p in params
    #  puts p
    #end
    puts params[:actions]
    #@test = params[:actions].new(params[:name])
    #@test.save
    #if params[:actions].find(:first, :conditions=>"#{params[:actions]}.test = '#{word}'") == nil
    #  test = params[:actions].new
    #  test.test = word
    #  test.save
    #end
    stop_words.new = "toto"
  end
  
  def dictionaries
    @dictionaries = Dictionary.find(:all)
    render :partial=>"dictionaries"
  end
  
  def stop_words
    @stop_words = StopWord.find(:all)
    render :partial=>"stop_words"
  end
  
  def synonym_words
    @synonym_words = SynonymWord.find(:all)
    render :partial=>"synonym_words"
  end
  
  def destroy_dictionary
    @dictionary = Dictionary.find(params[:id])
    @dictionary.destroy
    redirect_to "/admin/yahoo_boss/dictionaries"
  end
  
  def destroy_stop_word
    @stop_word = StopWord.find(params[:id])
    @stop_word.destroy
    redirect_to "/admin/yahoo_boss/stop_words"
  end 
  
  def destroy_synonym_word
    @synonym_word = SynonymWord.find(params[:id])
    @synonym_word.destroy
    redirect_to "/admin/yahoo_boss/synonym_words"
  end
  
end