require 'optparse'
require 'open-uri'
require 'fileutils'
require 'tempfile'

include FileUtils

module Radiant
  module Commands
    class Extension
      attr_reader :script_name
      
      def initialize
        @script_name = File.basename($0)
      end
      
      def options
        OptionParser.new do |o|
          o.set_summary_indent('  ')
          o.banner = "Usage: #{@script_name} [OPTIONS] command"
          o.define_head "Radiant extension manager."
          
          o.separator ""
          o.separator "GENERAL OPTIONS"
          
          o.on("-h", "--help", "Show this help message.") { puts o; exit }

          o.separator ""
          o.separator "COMMANDS"
          
          o.separator "  install    Install extension(s)."
          o.separator "  uninstall  Uninstall extension(s)."
          o.separator "  search     Search the extensions registry for extensions."
          o.separator "  update     Update installed extension(s)."
          o.separator "  list       List installed or available extensions."
          o.separator "  info       Get information about an extension."
        end
      end
      
      def split_args(args)
        left = []
        left << args.shift while args[0] and args[0] =~ /^-/
        left << args.shift if args[0]
        return [left, args]
      end
      
      def parse!(argv=ARGV)
        general, sub = split_args(args)
        options.parse!(general)
        
        command = general.shift
        if command =~ /^(install|uninstall|update|list|info)$/
          command = Commands.const_get(command.capitalize).new(self)
          command.parse!(sub)
        else
          puts "Unknown command: #{command}"
          puts options
          exit 1
        end
      end
      
      def self.parse!(argv=ARGV)
        Extension.new.parse!(argv)
      end
    end
    
    class Install
    end
    
    class Uninstall
    end
    
    class Update
    end
    
    class List
      def initialize(base_command)
        @base_command = base_command
        @local = true
        @remote = false
      end
      
      def options
        OptionParser.new do |o|
          o.set_summary_indent('  ')
          o.banner =    "Usage: #{@base_command.script_name} list [OPTIONS] [PATTERN]"
          o.define_head "List available extensions."
          o.separator   ""
          o.separator   "Options:"
          o.separator   ""
          o.on(         "--local", "List locally installed extensions.") {|@local| @remote = false}
          o.on(         "--remote", "List remotely available extensions.  This is the default behavior",
                        "unless --local is provided."){|@remote|}
        end
      end
      
      def parse!(args)
        options.order!(args)
        if @remote

        else
          cd "#{@base_command.environment.root}/vendor/extensions"
          Dir["*"].select{|p| File.directory?(p)}.each do |name|
            puts name
          end
        end
      end
    end
    
    class Info
    end
  end
end

# Ripped from Rails Command::Plugin
class RecursiveHTTPFetcher
  attr_accessor :quiet
  def initialize(urls_to_fetch, cwd = ".")
    @cwd = cwd
    @urls_to_fetch = urls_to_fetch.to_a
    @quiet = false
  end

  def ls
    @urls_to_fetch.collect do |url|
      if url =~ /^svn:\/\/.*/
        `svn ls #{url}`.split("\n").map {|entry| "/#{entry}"} rescue nil
      else
        open(url) do |stream|
          links("", stream.read)
        end rescue nil
      end
    end.flatten
  end

  def push_d(dir)
    @cwd = File.join(@cwd, dir)
    FileUtils.mkdir_p(@cwd)
  end

  def pop_d
    @cwd = File.dirname(@cwd)
  end

  def links(base_url, contents)
    links = []
    contents.scan(/href\s*=\s*\"*[^\">]*/i) do |link|
      link = link.sub(/href="/i, "")
      next if link =~ /^http/i || link =~ /^\./
      links << File.join(base_url, link)
    end
    links
  end
  
  def download(link)
    puts "+ #{File.join(@cwd, File.basename(link))}" unless @quiet
    open(link) do |stream|
      File.open(File.join(@cwd, File.basename(link)), "wb") do |file|
        file.write(stream.read)
      end
    end
  end
  
  def fetch(links = @urls_to_fetch)
    links.each do |l|
      (l =~ /\/$/ || links == @urls_to_fetch) ? fetch_dir(l) : download(l)
    end
  end
  
  def fetch_dir(url)
    push_d(File.basename(url))
    open(url) do |stream|
      contents =  stream.read
      fetch(links(url, contents))
    end
    pop_d
  end
end

Radiant::Commands::Extension.parse!