class Admin::MenuChoicesController < ApplicationController
  make_resourceful do
    actions :all

    before(:new) do
      @menu_choice.event_option = EventOption.find params[:event_option_id]
    end

    response_for(:show, :destroy, :update) do
      redirect_to edit_admin_event_option_path(@menu_choice.event_option) 
    end

  end
end
