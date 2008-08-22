module Admin::TemplatesHelper
  def no_tag tag
    "&lt;#{tag.to_s}&gt;"
  end
end
