ActionController::Routing::Routes.draw do |map|

  # Admin
  map.admin            'admin',                              :controller => 'admin/welcome',  :action => 'index'

  # Welcome
  map.welcome          'admin/welcome',                      :controller => 'admin/welcome',  :action => 'index'
  map.login            'admin/login',                        :controller => 'admin/welcome',  :action => 'login'
  map.logout           'admin/logout',                       :controller => 'admin/welcome',  :action => 'logout'
                       
  # Pages              
  map.page_index       'admin/pages',                        :controller => 'admin/page',     :action => 'index'
  map.page_edit        'admin/pages/edit/:id',               :controller => 'admin/page',     :action => 'edit'
  map.page_new         'admin/pages/:parent_id/child/new',   :controller => 'admin/page',     :action => 'new'
  map.homepage_new     'admin/pages/new/homepage',           :controller => 'admin/page',     :action => 'new',        :slug => '/', :breadcrumb => 'Home'
  map.page_remove      'admin/pages/remove/:id',             :controller => 'admin/page',     :action => 'remove'
  map.page_add_part    'admin/ui/pages/part/add',            :controller => 'admin/page',     :action => 'add_part'
  map.page_children    'admin/ui/pages/children/:id/:level', :controller => 'admin/page',     :action => 'children',   :level => '1'
  map.clear_cache      'admin/pages/cache/clear',            :controller => 'admin/page',     :action => 'clear_cache'
  
  # Layouts            
  map.layout_index     'admin/layouts',                      :controller => 'admin/layout',   :action => 'index'
  map.layout_edit      'admin/layouts/edit/:id',             :controller => 'admin/layout',   :action => 'edit'
  map.layout_new       'admin/layouts/new',                  :controller => 'admin/layout',   :action => 'new'
  map.layout_remove    'admin/layouts/remove/:id',           :controller => 'admin/layout',   :action => 'remove'
                       
  # Snippets           
  map.snippet_index    'admin/snippets',                     :controller => 'admin/snippet',  :action => 'index'
  map.snippet_edit     'admin/snippets/edit/:id',            :controller => 'admin/snippet',  :action => 'edit'
  map.snippet_new      'admin/snippets/new',                 :controller => 'admin/snippet',  :action => 'new'
  map.snippet_remove   'admin/snippets/remove/:id',          :controller => 'admin/snippet',  :action => 'remove'
                       
  # Users              
  map.user_index       'admin/users',                        :controller => 'admin/user',     :action => 'index'
  map.user_edit        'admin/users/edit/:id',               :controller => 'admin/user',     :action => 'edit'
  map.user_new         'admin/users/new',                    :controller => 'admin/user',     :action => 'new'
  map.user_remove      'admin/users/remove/:id',             :controller => 'admin/user',     :action => 'remove'
  map.user_preferences 'admin/preferences',                  :controller => 'admin/user',     :action => 'preferences'

  # Site URLs
  map.homepage         '',                                 :controller => 'site',           :action => 'show_page', :url => '/'
  map.not_found        'error/404',                        :controller => 'site',           :action => 'not_found'
  map.error            'error/500',                        :controller => 'site',           :action => 'error'
  
  # Everything else
  map.connect          '*url',                             :controller => 'site',           :action => 'show_page'
  
end
