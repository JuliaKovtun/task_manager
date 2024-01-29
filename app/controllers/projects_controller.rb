class ProjectsController < ApplicationController
  before_action :set_project, only: %i[show update destroy]

  def index
    cache_key = "projects_#{Project.maximum(:updated_at)}"
    @projects = Rails.cache.fetch(cache_key, expires_in: 1.hour) do
      Project.with_tasks
    end
  end

  def show; end

  def create
    @project = Project.new(project_params)

    if @project.save
      render json: @project, status: :created
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  def update
    if @project.update(project_params)
      render json: @project
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @project.destroy
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:title, :description)
  end
end
