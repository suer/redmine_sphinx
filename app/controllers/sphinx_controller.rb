class SphinxController < ApplicationController
  unloadable

  before_filter :find_project

  def index
    @documents = @project.repositories
                         .select { |r| SphinxDocument.sphinx_document?(r) }
                         .map { |r| SphinxDocument.new(r) }
  end

  def show
    @identifier = params[:identifier]
    document = find_document(@identifier)
    document.make_html
    redirect_to :action => 'static', :id => @project.id, :identifier => @identifier, :path => 'AsakusaSatellite/manual/index.html'
  end

  def static
    path = params[:path] || ''
    @identifier = params[:identifier]
    document = find_document(@identifier)
    real_path = document.build_root + path
    real_path += "." + params[:format] unless params[:format].blank?
    if File.file?(real_path)
      render :text => open(real_path, "rb").read , :layout => false
    elsif File.directory?(real_path)
      # TODO
    end
  end

  private
  def find_document(identifier)
    repository = if identifier.blank?
      @project.repository
    else
      @project.repositories.find { |r| r.identifier == @identifier }
    end
    SphinxDocument.new(repository)
  end

  def find_project
    @project = Project.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end

