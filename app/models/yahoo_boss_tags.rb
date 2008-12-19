module YahooBossTags
  include Radiant::Taggable
  
  desc %{
    This is the base tag for yahoo_boss searches.<br/>
    If you don't give the type you want, it will use the three at the same time
    
    *Usage:*
    <pre><r:yahoo_boss [type="news/images/web"]> ... </r:yahoo_bosss></pre>
  }
  tag "yahoo_boss" do |tag|
    result = []
    result << "<form name='search' action='/yahoo_boss/search'>\n"
    if tag.attr["type"]
      tag.locals.type_ = tag.attr["type"]
      result << "<input type='hidden' name='search_type' value='#{tag.attr["type"]}'/>\n"
    else
      tag.locals.type_ = "all"
      result << "<input type='hidden' name='search_type' value='all'/>\n"
    end
    result << tag.expand
    result << "<input type='submit' value='Search this'/>"
    result << "</form>\n"
    
    result
  end
  
  
  tag "yahoo_boss:search_box" do |tag|
    if tag.attr["value"]
      "<input type='text' name='search_string' value='#{tag.attr["value"]}'/>"
    else
      "<input type='text' name='search_string'/>"
    end
  end
  
  tag "yahoo_boss:region" do |tag|
    if tag.attr["value"]
      "<input type='hidden' name='search[region]' value='#{tag.attr["value"]}'/>"
    end
  end
  
  tag "yahoo_boss:sites" do |tag|
    if tag.attr["value"]
      "<input type='hidden' name='search[sites]' value='#{tag.attr["value"]}'/>"
    end
  end
  
  tag "yahoo_boss:web_filter" do |tag|
    if tag.attr["value"] and ( tag.locals.type_ == "web" or tag.locals.type_ == "all")
      "<input type='hidden' name='web[filter]' value='#{tag.attr["value"]}'/>"
    end
  end
  
  tag "yahoo_boss:images_filter" do |tag|
    if tag.attr["value"] and ( tag.locals.type_ == "images" or tag.locals.type_ == "all")
      "<input type='hidden' name='images[filter]' value='#{tag.attr["value"]}'/>"
    end
  end
  
  tag "yahoo_boss:type" do |tag|
    if tag.attr["value"] and ( tag.locals.type_ == "web" or tag.locals.type_ == "all")
      "<input type='hidden' name='web[type]' value='#{tag.attr["value"]}'/>"
    end
  end
  
  tag "yahoo_boss:dimensions" do |tag|
    if tag.attr["value"] and ( tag.locals.type_ == "images" or tag.locals.type_ == "all")
      "<input type='hidden' name='images[dimensions]' value='#{tag.attr["value"]}'/>"
    end
  end
  
  tag "yahoo_boss:refererurl" do |tag|
    if tag.attr["value"] and ( tag.locals.type_ == "images" or tag.locals.type_ == "all")
      "<input type='hidden' name='images[refererurl]' value='#{tag.attr["value"]}'/>"
    end
  end
  
  tag "yahoo_boss:url" do |tag|
    if tag.attr["value"] and ( tag.locals.type_ == "images" or tag.locals.type_ == "all")
      "<input type='hidden' name='images[url]' value='#{tag.attr["value"]}'/>"
    end
  end
  
  tag "yahoo_boss:age" do |tag|
    if tag.attr["value"] and ( tag.locals.type_ == "news" or tag.locals.type_ == "all")
      "<input type='hidden' name='news[region]' value='#{tag.attr["value"]}'/>"
    end
  end
  
  
  
end
