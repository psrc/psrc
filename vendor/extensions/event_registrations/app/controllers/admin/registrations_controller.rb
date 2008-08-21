class Admin::RegistrationsController < ApplicationController
  def show
    @event = Event.find params[:id]
  end
end
