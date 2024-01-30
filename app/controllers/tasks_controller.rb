# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_project
  before_action :set_task, only: %i[show update destroy]

  def index
    @tasks = params[:status] ? @project.tasks.with_status(params[:status]) : @project.tasks
    render json: @tasks
  end

  def show
    render json: @task
  end

  def create
    @task = @project.tasks.new(task_params)

    if @task.save
      render json: @task, status: :created
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      render json: @task
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :status)
  end

  def set_task
    @task = @project.tasks.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: I18n.t('errors.task_not_found') }, status: :not_found
  end

  def set_project
    @project = Project.find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: I18n.t('errors.project_not_found') }, status: :not_found
  end
end
