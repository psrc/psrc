require 'digest/sha1'
require 'feedzirra'

class FeedCache
  include Simpleton

  attr_accessor :cache_dir

  def get(url)
    FileUtils.mkdir_p(cache_dir) unless File.directory?(cache_dir)

    # Caches full feed
    #
    # This used to attempt to update the cached feed like so:
    #
    #   feed = Feedzirra::Feed.update(feed)
    #
    # which worked fine on ruby 1.8.7, but returned an empty array on ree.
    #
    # It should be fine to re-fetch the entire feed as long as it's being
    # cached for a long period of time (6 hours in this case).
    if cache_exists?(url) && !update_cache?(url)
      feed = load_from_cache(url)
      feed
    else
      feed = Feedzirra::Feed.fetch_and_parse(url)
      save_to_cache(url, feed)
      feed
    end
  end

  private

  def cache_file(url)
    File.join(cache_dir, cache_key(url))
  end

  def cache_exists?(url)
    File.exist?(cache_file(url))
  end

  def update_cache?(url)
    File.mtime(cache_file(url)) < 1.hour.ago
  end

  def cache_key(url)
    Digest::SHA1.hexdigest(url)
  end

  def load_from_cache(url)
    Marshal.load(File.read(cache_file(url)))
  end

  def save_to_cache(url, object)
    unless object.is_a?(Fixnum)
      File.open(cache_file(url), "w") {|f| f.write Marshal.dump(object) }
    end
  end

  def initialize
    @cache_dir = "#{RAILS_ROOT}/tmp/feed_cache"
  end
end
