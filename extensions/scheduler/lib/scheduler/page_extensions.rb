module Scheduler::PageExtensions
  def self.included(base)
    base.extend ClassMethods
    class << base
      alias_method_chain :find_by_url, :scheduling
    end
  end

  module ClassMethods
    def find_by_url_with_scheduling(url, live=true)
      if live
        with_scope(:find => {:conditions => "((appears_on IS NULL AND expires_on IS NULL) OR (appears_on IS NULL AND NOW() <= expires_on) OR (expires_on IS NULL AND NOW() >= appears_on) OR (NOW() BETWEEN appears_on AND expires_on))"}) do
          find_by_url_without_scheduling(url, live)
        end
      else
        find_by_url_without_scheduling(url, live)
      end
    end
  end
end
