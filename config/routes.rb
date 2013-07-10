# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
match 'projects/:id/sphinx/:action(.:format)', :controller => 'sphinx'

