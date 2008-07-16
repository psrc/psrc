class UsersAndPagesScenario < Scenario::Base
  uses :pages, :users
  
  def load
    UserActionObserver.current_user = users(:admin)
    Page.update_all "created_by = #{user_id(:admin)}, updated_by = #{user_id(:admin)}"
    create_page "No User"
  end
end