# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
match 'projects/:id/sphinx(/:identifier)/static/*path', :controller => :sphinx, :action => :static
match 'projects/:id/sphinx/:action(.:format)', :controller => :sphinx

