module Radiant
  module FixtureLoadingExtension
    def self.included(base)
      class << base
        include ClassMethods
        alias_method_chain :create_fixtures, :multiple_paths
      end
    end
  end
  
  module ClassMethods
    def create_fixtures_with_multiple_paths(fixtures_directory, table_names, class_names = {})
      table_names = [table_names].flatten.map { |n| n.to_s }
      connection = block_given? ? yield : ActiveRecord::Base.connection
      ActiveRecord::Base.silence do
        fixtures_map = {}
        fixtures = table_names.map do |table_name|
          paths = fixtures_directory.dup
          begin
            directory = paths.pop
            fixtures_map[table_name] = Fixtures.new(connection, File.split(table_name.to_s).last, class_names[table_name.to_sym], File.join(directory, table_name))
          rescue Exception => e
            retry unless paths.empty?
            raise e
          end
        end               
        all_loaded_fixtures.merge! fixtures_map  
  
        connection.transaction(Thread.current['open_transactions'] == 0) do
          fixtures.reverse.each { |fixture| fixture.delete_existing_fixtures }
          fixtures.each { |fixture| fixture.insert_fixtures }
  
          # Cap primary key sequences to max(pk).
          if connection.respond_to?(:reset_pk_sequence!)
            table_names.each do |table_name|
              connection.reset_pk_sequence!(table_name)
            end
          end
        end
  
        return fixtures.size > 1 ? fixtures : fixtures.first
      end
    end  
  end
end

require 'active_record/fixtures'
Fixtures.class_eval { include Radiant::FixtureLoadingExtension }

require 'action_controller/test_process'
class ActionController::TestProcess
  def fixture_file_upload(path, mime_type = nil)
    if Test::Unit::TestCase.respond_to?(:fixture_path)
      fixture_path = Test::Unit::TestCase.fixture_path
      if(fixture_path.respond_to? :to_str)
        ActionController::TestUploadedFile.new(
          fixture_path.to_str + path, 
          mime_type
        )
      else
        best_path = fixture_path.find { |x| File.exist? (x + path) }
        best_path ||= fixture_path.last
        ActionController::TestUploadedFile.new(
          best_path + path, 
          mime_type
        )        
      end
    else
      ActionController::TestUploadedFile.new(
        path, 
        mime_type
      )
    end
  end
end

