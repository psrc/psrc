class ActivityLogExtension < Radiant::Extension
  version "0.1"
  description "Tracks activity on Radiant resources"
  url "http://www.psrc.org/"

  define_routes do |map|
    map.admin_activities 'admin/activities.:format', :controller => 'admin/activities'
  end

  def activate
    User.send :has_many, :activities
    Asset.send :include, ActivityModel
    Page.send :include, ActivityModel

    UserActionObserver.class_eval do
      def before_destroy(model)
        model.updated_by = self.class.current_user
      end
    end
  end
end
