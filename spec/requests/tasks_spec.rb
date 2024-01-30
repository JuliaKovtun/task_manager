# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :request do
  let!(:project) { create(:project) }
  let!(:task) { create(:task, project_id: project.id) }
  let!(:user) { create(:user) }

  before do
    allow_any_instance_of(TasksController).to receive(:current_user).and_return(user)
  end

  context 'when user is not authenticated' do
    before do
      allow_any_instance_of(TasksController).to receive(:current_user).and_return(nil)
    end

    it 'returns 401 status with message' do
      get project_tasks_path(project_id: project.id), as: :json
      expect(response).to have_http_status(401)
      expect(response.body).to include('You need to sign in or sign up before continuing.')
    end
  end

  describe 'GET /projects/:project_id/tasks' do
    let!(:new_task) { create(:task, title: 'New task', project_id: project.id) }
    let!(:in_progress_task) { create(:task, title: 'Task in progress', project_id: project.id, status: :in_progress) }

    context 'without filter by status' do
      it 'shows all tasks' do
        get project_tasks_path(project_id: project.id), as: :json
        expect(response).to have_http_status(200)
        expect(response.body).to include(task.title)
        expect(response.body).to include(new_task.title)
        expect(response.body).to include(in_progress_task.title)
      end
    end

    context 'with filter by status' do
      it 'shows all tasks with specific status' do
        get project_tasks_path(project_id: project.id, status: 'new'), as: :json
        expect(response).to have_http_status(200)
        expect(response.body).to include(task.title)
        expect(response.body).to include(new_task.title)
        expect(response.body).to_not include(in_progress_task.title)
      end
    end

    context 'when project does not exist' do
      it 'returns a 404 status code with an error message' do
        get project_tasks_path(project_id: 'nonexistent_id'), as: :json
        expect(response).to have_http_status(404)
        expect(response.body).to include('Project not found')
      end
    end
  end

  describe 'GET /projects/:project_id/tasks/:id' do
    context 'when task and project exist' do
      it 'shows task' do
        get project_task_path(project_id: project.id, id: task.id), as: :json
        expect(response).to have_http_status(200)
        expect(response.body).to include(task.title)
      end
    end

    context 'when project does not exist' do
      it 'returns a 404 status code with an error message' do
        get project_task_path(project_id: 'nonexistent_id', id: task.id), as: :json
        expect(response).to have_http_status(404)
        expect(response.body).to include('Project not found')
      end
    end

    context 'when task does not exist in the project' do
      let!(:another_task) { create(:task, title: 'Another task title') }

      it 'returns a 404 status code with an error message' do
        get project_task_path(project_id: project.id, id: another_task.id), as: :json
        expect(response).to have_http_status(404)
        expect(response.body).to include('Task not found')
      end
    end

    context 'when task does not exist' do
      it 'returns a 404 status code with an error message' do
        get project_task_path(project_id: project.id, id: 'nonexistent_id'), as: :json
        expect(response).to have_http_status(404)
        expect(response.body).to include('Task not found')
      end
    end
  end

  describe 'POST /projects/:project_id/tasks' do
    context 'with valid params' do
      let(:task_params) { { title: 'Task', description: 'The description of task.' } }

      it 'creates task' do
        expect do
          post "/projects/#{project.id}/tasks", params: { task: task_params }, as: :json
        end.to change(Task, :count).by(1)
      end

      it 'returns status code 201' do
        post "/projects/#{project.id}/tasks", params: { task: task_params }, as: :json
        expect(response).to have_http_status(201)
      end
    end

    context 'with invalid params' do
      let(:task_params) { { title: '', description: 'The description of task.' } }

      it 'does not create task' do
        expect do
          post "/projects/#{project.id}/tasks", params: { task: task_params }, as: :json
        end.to_not change(Task, :count)
      end

      it 'returns status code 422' do
        post "/projects/#{project.id}/tasks", params: { task: task_params }, as: :json
        expect(response).to have_http_status(422)
      end
    end

    context 'when project does not exist' do
      let(:task_params) { { title: 'Task', description: 'The description of task.' } }

      it 'returns a 404 status code with an error message' do
        post '/projects/nonexistent_id/tasks', params: { task: task_params }, as: :json
        expect(response).to have_http_status(404)
        expect(response.body).to include('Project not found')
      end
    end
  end

  describe 'PUT /projects/:project_id/tasks/:id' do
    context 'with valid params' do
      let(:task_params) { { title: 'other task title' } }

      it 'updates the task' do
        put "/projects/#{project.id}/tasks/#{task.id}", params: { task: task_params }, as: :json
        task.reload
        expect(task.title).to eq(task_params[:title])
      end

      it 'returns status code 200' do
        put "/projects/#{project.id}/tasks/#{task.id}", params: { task: task_params }, as: :json
        expect(response).to have_http_status(200)
      end
    end

    context 'with invalid params' do
      let(:task_params) { { title: '' } }

      it 'does not update the task' do
        original_title = task.title
        put "/projects/#{project.id}/tasks/#{task.id}", params: { task: task_params }, as: :json
        task.reload
        expect(task.title).to eq(original_title)
      end

      it 'returns status code 422' do
        put "/projects/#{project.id}/tasks/#{task.id}", params: { task: task_params }, as: :json
        expect(response).to have_http_status(422)
      end
    end

    context 'when project does not exist' do
      let(:task_params) { { title: 'other task title' } }

      it 'returns a 404 status code with an error message' do
        put "/projects/nonexistent_id/tasks/#{task.id}", params: { task: task_params }, as: :json
        expect(response).to have_http_status(404)
        expect(response.body).to include('Project not found')
      end
    end

    context 'when task does not exist in the project' do
      let(:task_params) { { title: 'other task title' } }
      let!(:another_task) { create(:task, title: 'Another task title') }

      it 'returns a 404 status code with an error message' do
        put "/projects/#{project.id}/tasks/#{another_task.id}", params: { task: task_params }, as: :json
        expect(response).to have_http_status(404)
        expect(response.body).to include('Task not found')
      end
    end

    context 'when task does not exist' do
      let(:task_params) { { title: 'other task title' } }

      it 'returns a 404 status code with an error message' do
        put "/projects/#{project.id}/tasks/nonexistent_id", params: { task: task_params }, as: :json
        expect(response).to have_http_status(404)
        expect(response.body).to include('Task not found')
      end
    end
  end

  describe 'DELETE /projects/:project_id/tasks/:id' do
    context 'when task exists' do
      it 'deletes the task' do
        expect { delete "/projects/#{project.id}/tasks/#{task.id}", as: :json }.to change(Task, :count).by(-1)
      end
    end

    context 'when project does not exist' do
      it 'returns a 404 status code with an error message' do
        delete "/projects/nonexistent_id/tasks/#{task.id}", as: :json
        expect(response).to have_http_status(404)
        expect(response.body).to include('Project not found')
      end
    end

    context 'when task does not exist in the project' do
      let!(:another_task) { create(:task, title: 'Another task title') }

      it 'returns a 404 status code with an error message' do
        delete "/projects/#{project.id}/tasks/#{another_task.id}", as: :json
        expect(response).to have_http_status(404)
        expect(response.body).to include('Task not found')
      end
    end

    context 'when task does not exist' do
      it 'returns a 404 status code with an error message' do
        delete "/projects/#{project.id}/tasks/nonexistent_id", as: :json
        expect(response).to have_http_status(404)
        expect(response.body).to include('Task not found')
      end
    end
  end
end
