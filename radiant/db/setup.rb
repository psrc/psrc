#!/usr/bin/env ruby

RAILS_ENV = 'development'
TEMPLATES_DIR = File.join(File.dirname(__FILE__), 'templates')

require 'optparse'

class DatabaseSetupApplication
  def self.run(args = ARGV)
    new.run(args)
  end
  
  attr_reader :params, :force, :help, :env
  
  def run(args = [])
    parse_args(args)
    announce_additional_options
    load_environment
    overwrite_check
    create_tables
    create_admin_user
    initialize_configuration
    if @template_filename
      @template = load_template(@template_filename)
    else
      select_template
    end
    create_records_from_template
    announce_finished
  end
  
  def parse_args(args)
    @env = 'development'
    @overwrite_warning = true
    @template_filename = nil
    
    opts = OptionParser.new do |opts|
      opts.banner =  "Usage: #{File.basename($0)} [options]"
      opts.separator "Setup Radiant database for the appropriate environment."
      opts.separator ""
      
      opts.separator "Options:"
      
      opts.on("-e", "--environment ENV", [:development, :production, :test], 
        "Setup the database for environment. ENV may be set to development,",
        "production, or test (default: development).") do |env|
        @env = env.to_s.downcase
      end
      
      opts.on("-o", "--overwrite", "Overwrite all data in tables. Do not display the overwrite warning.") do
        @overwrite_warning = false
      end
      
      opts.on("-t", "--template FILENAME", "Use the template specified in FILENAME.") do |filename|
        @template_filename = filename
      end
      
      opts.on("-?", "--help") do
        puts opts
        exit
      end
    end
    
    begin
      opts.parse(args)
    rescue OptionParser::ParseError => e
      puts e.message.capitalize
      puts
      puts opts
      exit
    end
    
    RAILS_ENV.replace(@env)
  end
  
  def announce_additional_options
    puts "Run `#{File.basename($0)} --help` for information on additional options."
    puts
  end
  
  def load_environment
    announce "Loading #{env} environment" do
      require File.dirname(__FILE__) + '/../config/environment'
    end
  end

  def overwrite_check
    if @overwrite_warning
      puts
      if ask_yes_or_no "WARNING! This script will overwrite information currently stored in the\n" + 
                       "database #{(ActiveRecord::Base.configurations[env]['database']).inspect}. " + 
                       "Are you sure you want to continue"
        puts
      else
        puts
        puts "Setup canceled."
        exit
      end
    end
  end
  
  def create_tables
    announce "Creating tables" do
      puts
      ActiveRecord::Schema.define(:version => 9) do
        create_table "config", :force => true do |t|
          t.column "key", :string, :limit => 40, :default => "", :null => false
          t.column "value", :string, :default => ""
        end
        add_index "config", ["key"], :name => "key", :unique => true

        create_table "layouts", :force => true do |t|
          t.column "name", :string, :limit => 100
          t.column "content", :text
          t.column "content_type", :string, :limit => 40
          t.column "created_at", :datetime
          t.column "updated_at", :datetime
          t.column "created_by", :integer
          t.column "updated_by", :integer
        end

        create_table "page_parts", :force => true do |t|
          t.column "name", :string, :limit => 100
          t.column "filter_id", :string, :limit => 25
          t.column "content", :text
          t.column "page_id", :integer
        end

        create_table "pages", :force => true do |t|
          t.column "title", :string
          t.column "slug", :string, :limit => 100
          t.column "breadcrumb", :string, :limit => 160
          t.column "parent_id", :integer
          t.column "layout_id", :integer
          t.column "behavior_id", :string, :limit => 25
          t.column "status_id", :integer, :default => 1, :null => false
          t.column "created_at", :datetime
          t.column "updated_at", :datetime
          t.column "published_at", :datetime
          t.column "created_by", :integer
          t.column "updated_by", :integer
          t.column "virtual", :boolean, :default => false, :null => false
        end

        create_table "snippets", :force => true do |t|
          t.column "name", :string, :limit => 100, :default => "", :null => false
          t.column "filter_id", :string, :limit => 25
          t.column "content", :text
          t.column "created_at", :datetime
          t.column "updated_at", :datetime
          t.column "created_by", :integer
          t.column "updated_by", :integer
        end
        add_index "snippets", ["name"], :name => "name", :unique => true

        create_table "users", :force => true do |t|
          t.column "name", :string, :limit => 100
          t.column "email", :string
          t.column "login", :string, :limit => 40, :default => "", :null => false
          t.column "password", :string, :limit => 40
          t.column "admin", :boolean, :default => false, :null => false
          t.column "developer", :boolean, :default => false, :null => false
          t.column "created_at", :datetime
          t.column "updated_at", :datetime
          t.column "created_by", :integer
          t.column "updated_by", :integer
        end
        add_index "users", ["login"], :name => "login", :unique => true
      end
    end
  end
  
  def create_admin_user
    announce "Creating user 'admin' with password 'radiant'" do
      @admin = User.create :name => 'Administrator', :login => 'admin', :password => 'radiant', :password_confirmation => 'radiant', :admin => true
      @admin = User.find(@admin.id)
      UserActionObserver.current_user = @admin
      @admin.created_by = @admin
      @admin.save
    end
  end
  
  def initialize_configuration
    announce "Initializing configuration" do
      config = Radiant::Config
      config['admin.title'   ] = 'Radiant CMS'
      config['admin.subtitle'] = 'Publishing for Small Teams'
      config['default.parts' ] = 'body, extended'
    end
  end
  
  def select_template
    templates = Dir[File.join(TEMPLATES_DIR, '*.yml')]
    templates.map! { |t| load_template(t) }
    templates = templates.sort_by { |t| t['name'] }
    loop do
      puts
      puts "Select a database template:"
      templates.each_with_index do |t, i|
        puts
        puts " #{i + 1}) #{t['name']}"
        t['description'].each_line { |line| puts "    #{line.strip}" }
      end
      puts
      print "[1-#{templates.size}] "
      selection = $1.to_i if gets.strip =~ /^(\d+)$/
      case selection
      when (1..templates.size)
        @template = templates[selection-1]
        puts
        break
      else
        puts
        invalid_option
      end
    end
  end
  
  def load_template(template)
    YAML.load_file(template)
  end
  
  def create_records_from_template
    records = @template['records']
    if records
      records.keys.each do |key|
        announce "Creating #{key.to_s.underscore.humanize}" do
          const = Object.const_get(key.to_s.singularize)
          record_pairs = records[key].map { |name, record| [record['id'], record] }.sort { |a, b| a[0] <=> b[0] }
          record_pairs.each do |id, record|
            const.new(record).save
          end
        end
      end
    end
  end
  
  def announce_finished
    puts
    puts "Finished."
  end
  
  def print(*args)
    $defout << args
    $defout.flush
  end
  
  def puts(*args)
    args << '' if args.size == 0
    print *(args.map { |a| "#{a}\n" })
  end
  
  def announce(something)
    print "#{something}..."
    yield
    puts "OK"
  rescue Exception => e
    puts "FAILED"
    raise e
  end
  
  def invalid_option
    puts "Invalid option."
    puts
  end
  
  def gets
    $stdin.gets
  end
  
  def ask_yes_or_no(question, default = :yes)
    prompt = (default == :yes) ? "[Yn]" : "[yN]"
    loop do
      print "#{question}? #{prompt} "
      case gets.strip.downcase
      when "yes", "y"
        break true
      when "no", "n"
        break false
      when ""
        break default == :yes
      else
        puts
        invalid_option
      end
    end
  end
end

DatabaseSetupApplication.run if __FILE__ == $0