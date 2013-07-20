class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :subject, :polymorphic => true
  serialize :subject_attributes, Hash
  serialize :user_attributes, Hash

  def subject_attribute(attribute, current = true)
    if current && subject
      subject.send(attribute)
    else
      subject_attributes[attribute.to_s] || 'N/A'
    end
  end

  def user_attribute(attribute, current = true)
    if current && user
      user.send(attribute)
    else
      user_attributes[attribute.to_s] || 'N/A'
    end
  end
end
