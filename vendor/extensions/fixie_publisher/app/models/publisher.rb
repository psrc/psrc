# Puts data from the development database into the production one
# (by deleting the production tables and recreating them and filling
# them with production data.
# Note: Obviously won't work with enforced database foreign keys,
# so don't make them.
# TODO: Also copy over user-provided photos from the dev env to the production one
class Publisher
  TABLES = %w( events event_options users page_parts pages layouts snippets )
  def self.publish!
    table_string = TABLES.map { |t| "-t #{t} " }
    data = `pg_dump #{current_dev} -a #{table_string}`
    puts data
    pg = IO::popen("psql #{current_prod}", "w+")

    pg << "begin;"
      TABLES.each do |table|
        pg << "delete from #{table};"
      end
      pg << data
    pg << "commit;"
  end

  private

  def self.current_dev
    config = Rails::Configuration.new
    config.database_configuration["development"]["database"]
  end

  def self.current_prod
    config = Rails::Configuration.new
    config.database_configuration["production"]["database"]
  end

end
