class SphinxDocument
  attr_reader :repository

  def self.sphinx_document?(repository)
    true # TODO
  end

  def initialize(repository)
    @repository = repository
    @project_id = repository.project.identifier
    @identifier = repository.identifier
  end

  def build_root
    git_dir = repository_path(@project_id, @identifier)
    git_dir + "/build/" # TODO from Makefile
  end

  def built_at
    git_dir = repository_path(@project_id, @identifier)
    if File.exists?(git_dir)
      File::mtime(git_dir)
    else
      nil
    end
  end

  def make_html
    if repository.scm_name == 'Git'
      git_bin = Redmine::Scm::Adapters::GitAdapter::GIT_BIN
      git_dir = repository_path(@project_id, @identifier)

      # delete old dirs
      delete if File.exists?(git_dir)

      # clone to repositories dir
      cmd = "#{git_bin} clone #{@repository.url} #{git_dir}"
      IO.popen(cmd, 'r+') { |io| puts io.gets }

      # make html
      make_bin = "make"
      cmd = "cd #{git_dir} && #{make_bin} html"
      system cmd
    end
  end

  def index_html
    git_dir = repository_path(@project_id, @identifier)
    manual_dir_line = open(git_dir + "/Makefile") { |f|
      f.readlines.select { |line| line =~ /^[\s]*MANUALDIR[\s]*=[\s]*.+[\s]*$/ }.first
    }
    if manual_dir_line
      manual_dir_line.split("=")[1].strip + "/index.html"
    else
      "html/index.html"
    end
  end

  private
  def delete
    FileUtils.rm_r([repository_path(@project_id, @identifier)])
  end

  def repository_path(project_id, identifier)
    File.join(tmp_sphinx_repositories_path, make_package_name(project_id, identifier))
  end

  def make_package_name(project_id, identifier)
     return project_id if identifier.blank?
    "#{identifier}@#{project_id}"
  end

  def tmp_path(root = Rails.root.to_s)
    File.join(root, 'tmp')
  end

  def tmp_sphinx_path
    create_unless_exist(File.join(tmp_path, 'sphinx'))
  end

  def tmp_sphinx_repositories_path
    create_unless_exist(File.join(tmp_sphinx_path, 'repositories'))
  end

  def create_unless_exist(path)
    FileUtils.mkdir_p(path) unless File.exist?(path)
    path
  end
end
