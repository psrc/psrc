module ActivityModel
  def self.included(base)
    base.send :has_many, :activities, :as => :subject
  end

  def cache_activity_attributes
    @activity_attributes = attributes.dup
  end

  def track_activity(action, user = nil, occurred_at = Time.now.utc)
    Activity.create! :action => action,
      :subject => self,
      :user => user,
      :subject_attributes => @activity_attributes || attributes,
      :user_attributes => user ? user.attributes.except('password', 'salt') : {},
      :occurred_at => occurred_at
  end
end
