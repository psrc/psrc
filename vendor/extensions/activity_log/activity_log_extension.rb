class ActivityLogExtension < Radiant::Extension
  version "0.1"
  description "Tracks activity on Radiant resources"
  url "http://www.psrc.org/"

  def activate
    User.class_eval do
      has_many :activities
    end

    Asset.class_eval do
      has_many :activities, :as => :subject

      after_create { |asset| asset.track_activity("created", asset.created_by) }
      after_update { |asset| asset.track_activity("updated", asset.updated_by) }
      after_destroy { |asset| asset.track_activity("destroyed", asset.updated_by) }

      def track_activity(action, user = nil, occurred_at = Time.now.utc)
        Activity.create! :action => action,
                         :subject => self,
                         :user => user,
                         :subject_attributes => attributes,
                         :user_attributes => user ? user.attributes.except('password', 'salt') : {},
                         :occurred_at => occurred_at
      end
    end

    UserActionObserver.class_eval do
      def before_destroy(model)
        model.updated_by = self.class.current_user
      end
    end
  end
end
