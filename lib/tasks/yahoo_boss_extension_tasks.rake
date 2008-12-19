namespace :radiant do
  namespace :extensions do
    namespace :yahoo_boss do
      
      desc "Runs the migration of the Yahoo Boss extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          YahooBossExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          YahooBossExtension.migrator.migrate
        end
      end
      
      desc "Copies public assets of the Yahoo Boss to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        Dir[YahooBossExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(YahooBossExtension.root, '')
          directory = File.dirname(path)
          puts "Copying #{path}..."
          mkdir_p RAILS_ROOT + directory
          cp file, RAILS_ROOT + path
        end
      end  
    end
  end
end
