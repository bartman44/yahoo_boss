class YahooBossController < ApplicationController
  no_login_required
  layout nil
  
  def report
    @url = "/yahoo_boss/search?search_type=#{params[:search_type]}&search_string=#{params[:search_string]}"
    if params[:search] != nil
      for p in params[:search]
        @url += "&search[#{p[0]}]=#{p[1]}"
      end
    end
    if params[:web] != nil
      for p in params[:web]
        @url += "&web[#{p[0]}]=#{p[1]}"
      end
    end
    if params[:images] != nil
      for p in params[:images]
        @url += "&images[#{p[0]}]=#{p[1]}"
      end
    end
    if params[:news] != nil
      for p in params[:news]
        @url += "&news[#{p[0]}]=#{p[1]}"
      end
    end
    render :partial=>"report"
  end
  
  def save_report
    @urls = []
    @results = {}
    
    params["search"] = Hash.new if params["search"] == nil
    params["web"] = Hash.new if params["web"] == nil
    params["images"] = Hash.new if params["images"] == nil
    params["news"] = Hash.new if params["news"] == nil
    if params["search_type"] == "all"
      @urls.push(build_search_url(params["search_string"], "web", params["search"].merge(params["web"]), 6))
      @urls.push(build_search_url(params["search_string"], "images", params["search"].merge(params["images"]), 6))
      @urls.push(build_search_url(params["search_string"], "news", params["search"].merge(params["news"]), 6))
      @results["web"] = format_result_web(open(@urls[0]).read) if @urls[0]
      @results["images"] = format_result_images(open(@urls[1]).read) if @urls[1]
      @results["news"] = format_result_news(open(@urls[2]).read) if @urls[2]
      for type_ in ["web","images","news"]
        for i in params[:results]   
          if i[0].include?(type_)
            report = SearchReport.new
            report.email = params[:makereport][:email]
            report.search_result = @results[type_][i[1].to_i]
            report.save
          end
        end
      end
      
    else
      @urls.push(build_search_url(params["search_string"], params["search_type"], params["search"].merge(params["news"]), 20))
      @results["web"] = format_result_web(open(@urls[0]).read) if params["search_type"] == "web"
      @results["images"] = format_result_images(open(@urls[0]).read) if params["search_type"] == "images"
      @results["news"] = format_result_news(open(@urls[0]).read) if params["search_type"] == "news"
      for i in params[:results]
        if i[0].include?(params["search_type"])
          report = SearchReport.new
          report.email = params[:makereport][:email]
          report.search_result = @results[params["search_type"]][i[1].to_i]
          report.save
        end
      end
    end
    redirect_to params[:url]
  end
  
  def search
    require 'open-uri'
    
    @urls = []
    @results = []

    if (params["search_string"]) == ""  #if there is nothing in search_string
      redirect_to "/"
    else
      params["search_string"].gsub!(" ", "+")
      for word in params["search_string"].split("+")
        if DailyQuery.find(:first, :conditions=>"daily_queries.query = '#{word}'") == nil
          query = DailyQuery.new
          query.query = word
          query.save
        end
      
      end
      params["search"] = Hash.new if params["search"] == nil
      params["web"] = Hash.new if params["web"] == nil
      params["images"] = Hash.new if params["images"] == nil
      params["news"] = Hash.new if params["news"] == nil
      if params["search_type"] == "all"
        @urls.push(build_search_url(params["search_string"], "web", params["search"].merge(params["web"]), 6))
        @urls.push(build_search_url(params["search_string"], "images", params["search"].merge(params["images"]), 6))
        @urls.push(build_search_url(params["search_string"], "news", params["search"].merge(params["news"]), 6))
        @results[0] = format_result_web(open(@urls[0]).read) if @urls[0]
        @results[1] = format_result_images(open(@urls[1]).read) if @urls[1]
        @results[2] = format_result_news(open(@urls[2]).read) if @urls[2]
      else
        @urls.push(build_search_url(params["search_string"], params["search_type"], params["search"].merge(params["news"]), 20))
        @results[0] = format_result_web(open(@urls[0]).read) if params["search_type"] == "web"
        @results[0] = format_result_images(open(@urls[0]).read) if params["search_type"] == "images"
        @results[0] = format_result_news(open(@urls[0]).read) if params["search_type"] == "news"
      end
    end
  end
  
  private
  def build_search_url(search, type, params, count)
    appid = YahooBoss.find(:first).key
    str = "http://boss.yahooapis.com/ysearch/#{type}/v1/#{search}?appid=#{appid}&format=xml&count=#{count}"
    if params
      for p in params
        if p != nil
          str += "&#{p[0]}=#{p[1]}"
        end
      end
    end
    return str
  end
  
  def format_result_web(result)
    doc = REXML::Document.new result
    ret = []
    i=0
    REXML::XPath.each(doc, '//result'){ |result|
      url = REXML::XPath.first(result, 'url').get_text
      disp_url = REXML::XPath.first(result, 'dispurl').get_text
      title = REXML::XPath.first(result, 'title').get_text
      text = REXML::XPath.first(result, 'abstract').get_text
      date = REXML::XPath.first(result, 'date').get_text
      
      str = "<div class='result'><a href='#{url}'>#{title}</a> <span><input type='checkbox' name='results[web_#{i}]' value='#{i}'/></span><br/>\n<p class='text'>#{text}</p>\n<p class='url'>#{disp_url}</p><span>Last update <i>#{date}</i></span></div>"
      ret << str
      i += 1
    }
    return ret
  end
  def format_result_images(result)
    doc = REXML::Document.new result
    ret = []
    i=0
    REXML::XPath.each(doc, '//result'){ |result|
      url = REXML::XPath.first(result, 'refererurl').get_text
      tumb = REXML::XPath.first(result, 'thumbnail_url').get_text
      title = REXML::XPath.first(result, 'title').get_text
      text = REXML::XPath.first(result, 'abstract').get_text
      date = REXML::XPath.first(result, 'date').get_text
      height = REXML::XPath.first(result, 'height').get_text
      width = REXML::XPath.first(result, 'width').get_text
      size = REXML::XPath.first(result, 'size').get_text
      type = REXML::XPath.first(result, 'format').get_text
      
      str = "<div class='result'><a href='#{url}'><img src='#{tumb}'/></a><span><input type='checkbox' name='results[images_#{i}]' value='#{i}'/></span><br/>\n<p class='text'>#{text}</p>\n"
      str += "<p>#{width}x#{height} - #{size.to_s.to_i/1024}ko - #{type}</p></div>"
      ret << str
      i += 1
    }
    return ret
  end
  def format_result_news(result)
    doc = REXML::Document.new result
    ret = []
    i=0
    REXML::XPath.each(doc, '//result'){ |result|
      url = REXML::XPath.first(result, 'url').get_text
      time = REXML::XPath.first(result, 'time').get_text
      title = REXML::XPath.first(result, 'title').get_text
      text = REXML::XPath.first(result, 'abstract').get_text
      date = REXML::XPath.first(result, 'date').get_text
      url = REXML::XPath.first(result, 'source').get_text
      source_url = REXML::XPath.first(result, 'sourceurl').get_text
      
      str = "<div class='result'><h3><a href='#{url}'>#{title}</a><span> - <input type='checkbox' name='results[news_#{i}]' value='#{i}'/></span></h3>\n<label class='site'>#{source_url}</label> - <label class='date'>#{date}</label><br/>\n"
      str += "<p class='text'>#{text}</p></div>"
      ret << str
      i += 1
    }
    return ret
  end
end