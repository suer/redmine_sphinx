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
    repository = @project.repositories.find { |r| r.identifier == @identifier }
    SphinxDocument.new(repository).make_html
  end

  private
  def find_project
    @project = Project.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end

