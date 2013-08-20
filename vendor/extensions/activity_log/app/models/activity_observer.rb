class ActivityObserver < ActiveRecord::Observer
  observe Asset

  def before_destroy(model)
    model.cache_activity_attributes
  end

  def after_create(model)
    model.track_activity("created", model.created_by)
  end

  def after_update(model)
    model.track_activity("updated", model.updated_by)
  end

  def after_destroy(model)
    model.track_activity("destroyed", model.updated_by)
  end
end
