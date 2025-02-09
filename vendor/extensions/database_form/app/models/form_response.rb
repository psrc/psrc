class FormResponse < ActiveRecord::Base
  validates_presence_of :name, :content
  validate :honeypot

  serialize :content
  has_many :form_files

  def to_xml(options = {})
    options[:indent] ||= 2
    xml = options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:indent])
    xml.instruct! unless options[:skip_instruct]
    xml.tag!("form-response", :id => id) do
      xml.tag!("created-at", created_at.strftime("%Y-%m-%d %H:%M"))
      content.each do |name, value|
        xml.tag!(name.dasherize, value)
      end
    end
  end

  # The nickname field should always be hidden, and therefore intentionally
  # blank. Any submissions with nickname filled out are likely spam bots.
  def honeypot
    if content && ! content['nickname'].blank?
      errors.add(:base, 'uhoh')
    else
      content.delete_if { |key, value| key == 'nickname' } if content
    end
  end
end
