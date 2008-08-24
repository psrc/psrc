module Admin::TemplatesHelper
  def page_header title
    html = ""
    html << "<div class='back'>#{ link_to "&laquo; Back to all templates", templates_path }</div"
    html << "<h2>#{title}</h2>"
  end
end
