Redmine::Plugin.register :redmine_sphinx do
  name 'Redmine Sphinx plugin'
  author 'suer'
  description 'This is a plugin for Redmine that support bulidig Sphinx documents'
  version '0.0.1'
  url 'https://github.com/suer/redmine_sphinx'
  author_url 'http://d.hatena.ne.jp/suer/'

  project_module :sphinx do
    permission :sphinx, {:sphinx => [:index]}, :public => true
    menu :project_menu, :sphinx, { :controller => 'sphinx', :action => 'index' }, :caption => :sphinx
  end
end
