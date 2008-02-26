# Only define freeze and unfreeze tasks in instance mode
unless File.directory? "#{RAILS_ROOT}/app"
  namespace :radiant do
    namespace :freeze do
      desc "Lock this application to the current gems (by unpacking them into vendor/radiant)"
      task :gems do
        require 'rubygems'
        Gem.manage_gems

        radiant = (version = ENV['VERSION']) ?
          Gem.cache.search('radiant', "= #{version}").first :
          Gem.cache.search('radiant').sort_by { |g| g.version }.last

        version ||= radiant.version

        unless radiant
          puts "No radiant gem #{version} is installed.  Do 'gem list radiant' to see what you have available."
          exit
        end

        puts "Freezing to the gems for Radiant #{radiant.version}"
        rm_rf   "vendor/radiant"

        chdir("vendor") do
          Gem::GemRunner.new.run(["unpack", "-v", "=#{version}", "radiant"])
          FileUtils.mv(Dir.glob("radiant*").first, "radiant")
        end
      end

      desc "Lock to latest Edge Radiant or a specific revision with REVISION=X (ex: REVISION=4021), a tag with TAG=Y (ex: TAG=rel_1-1-0), or a branch with BRANCH=Z (ex: BRANCH=mental)"
      task :edge do
        $verbose = false
        `svn --version` rescue nil
        unless !$?.nil? && $?.success?
          $stderr.puts "ERROR: Must have subversion (svn) available in the PATH to lock this application to Edge Radiant"
          exit 1
        end

        rm_rf   "vendor/radiant"
        mkdir_p "vendor/radiant"

        svn_root = "http://dev.radiantcms.org/svn/radiant/"

        case
        when ENV['TAG']
          radiant_svn = "#{svn_root}/tags/#{ENV['TAG']}"
          touch "vendor/radiant/TAG_#{ENV['TAG']}"
        when ENV['BRANCH']
          radiant_svn = "#{svn_root}/branches/#{ENV['BRANCH']}"
          touch "vendor/radiant/BRANCH_#{ENV['BRANCH']}"
        else
          radiant_svn = "#{svn_root}/trunk"

          if ENV['REVISION'].nil?
            ENV['REVISION'] = /^r(\d+)/.match(%x{svn -qr HEAD log #{svn_root}})[1]
            puts "REVISION not set. Using HEAD, which is revision #{ENV['REVISION']}."
          end

          touch "vendor/radiant/REVISION_#{ENV['REVISION']}"
        end
      
        system "svn export #{radiant_svn}/radiant vendor/radiant" + (ENV['REVISION'] ? " -r #{ENV['REVISION']}" : "") + " --force"
      end
    end

    desc "Unlock this application from freeze of gems or edge and return to a fluid use of system gems"
    task :unfreeze do
      rm_rf "vendor/radiant"
    end
    
    desc "Update both configs, scripts and public/javascripts from Radiant"
    task :update => [ "update:scripts", "update:javascripts", "update:configs", "update:images", "update:stylesheets" ]

    namespace :update do
      desc "Add new scripts to the instance script/ directory"
      task :scripts do
        local_base = "script"
        edge_base  = "#{File.dirname(__FILE__)}/../../scripts"
        
        local = Dir["#{local_base}/**/*"].reject { |path| File.directory?(path) }
        edge  = Dir["#{edge_base}/**/*"].reject { |path| File.directory?(path) }
        edge  = edge.reject { |f| f =~ /(generate|plugin|destroy)$/ }
        
        edge.each do |script|
          base_name = script[(edge_base.length+1)..-1]
          next if local.detect { |path| base_name == path[(local_base.length+1)..-1] }
          if !File.directory?("#{local_base}/#{File.dirname(base_name)}")
            mkdir_p "#{local_base}/#{File.dirname(base_name)}"
          end
          install script, "#{local_base}/#{base_name}", :mode => 0755
        end
        install "#{File.dirname(__FILE__)}/../generators/instance/templates/instance_generate", "#{local_base}/generate", :mode => 0755
      end

      desc "Update your javascripts from your current radiant install"
      task :javascripts do
        project_dir = RAILS_ROOT + '/public/javascripts/'
        scripts = Dir["#{File.dirname(__FILE__)}/../../public/javascripts/*.js"]
        scripts.reject!{|s| File.basename(s) == 'application.js'} if File.exists?(project_dir + 'application.js')
        FileUtils.cp(scripts, project_dir)
      end

      desc "Update config/boot.rb from your current radiant install"
      task :configs do
        FileUtils.cp("#{File.dirname(__FILE__)}/../generators/instance/templates/instance_boot.rb", RAILS_ROOT + '/config/boot.rb')
        instance_env = "#{RAILS_ROOT}/config/environment.rb"
        gen_env = "#{File.dirname(__FILE__)}/../generators/instance/templates/instance_environment.rb"
        backup_env = "#{RAILS_ROOT}/config/environment.bak"
        unless FileUtils.compare_file(instance_env, gen_env)
          FileUtils.cp(instance_env, backup_env)
          FileUtils.cp(gen_env, instance_env)
          puts "** WARNING **
config/environment.rb has changed in Radiant 0.6.5. Your original has been
backed up to config/environment.bak and replaced with the packaged version.
Please copy your customizations to the new file."
        end
      end
      
      desc "Update admin images from your current radiant install"
      task :images do
        project_dir = RAILS_ROOT + '/public/images/admin/'
        images = Dir["#{File.dirname(__FILE__)}/../../public/images/admin/*"]
        FileUtils.cp(images, project_dir)
      end
      
      desc "Update admin stylesheets from your current radiant install"
      task :stylesheets do
        project_dir = RAILS_ROOT + '/public/stylesheets/admin/'
        stylesheets = Dir["#{File.dirname(__FILE__)}/../../public/stylesheets/admin/*.css"]
        FileUtils.cp(stylesheets, project_dir)
      end      
    end
  end
end