# Puts data from the development database into the production one
# (by deleting the production tables and recreating them and filling
# them with production data.
# Note: Obviously won't work with enforced database foreign keys,
# so don't make them.
# TODO: Also copy over user-provided photos from the dev env to the production one
require 'open3'
class Publisher
  TABLES = %w( events event_options users page_parts pages layouts snippets assets banners banner_placements page_attachments )
  def self.publish!
    Bj.submit("./script/runner Publisher.publish_job")
  end

  # Ran by Bj
  def self.publish_job
    table_string = TABLES.map { |t| "-t #{t} " }
    dump_command = "/usr/local/bin/pg_dump #{ connection_options(RAILS_ENV) } #{current_dev} -a #{table_string}"
    psql_command = "/usr/local/bin/psql #{ connection_options("production") } #{current_prod}"
    puts "Dumping with #{ dump_command }"
    puts "Loading with #{ psql_command }"

    data = `#{dump_command}`
    Open3.popen3(psql_command) do |stdin, stdout, stderr| 
      stdin << "begin;"
      TABLES.each do |table|
        stdin << "delete from #{table};"
      end
      stdin << data
      stdin << "commit;"
      stdin.flush
    end

    `rsync -avz /sites/psrc-staging/shared/assets/ /sites/psrc-production/shared/assets/`
  end

  private

  def self.connection_options env
    config = Rails::Configuration.new.database_configuration[env]
    user = config["username"]
    host = config["host"]
    " -h #{ host } -U #{ user } " if user and host
  end

  def self.current_dev
    config = Rails::Configuration.new
    config.database_configuration[RAILS_ENV]["database"]
  end

  def self.current_prod
    config = Rails::Configuration.new
    config.database_configuration["production"]["database"]
  end

end

