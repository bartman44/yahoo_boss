# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class YahooBossExtension < Radiant::Extension
  version "1.0"
  description "Describe your extension here"
  url "http://yourwebsite.com/yahoo_boss"
  
  define_routes do |map|
    map.connect 'admin/yahoo_boss/:action', :controller => 'admin/yahoo_boss'
    map.connect 'yahoo_boss/:action', :controller => 'yahoo_boss'
  end
  
  def activate
    Page.send :include, YahooBossTags
    admin.tabs.add "Yahoo Boss", "/admin/yahoo_boss", :after => "Layouts", :visibility => [:all]
  end
  
  def deactivate
    # admin.tabs.remove "Yahoo Boss"
  end
  
end