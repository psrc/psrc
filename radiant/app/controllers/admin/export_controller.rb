class Admin::ExportController < ApplicationController
  def yaml
    response.headers['Content-Type'] = "text/yaml"
    render :text => Radiant::Exporter.export
  end
end
