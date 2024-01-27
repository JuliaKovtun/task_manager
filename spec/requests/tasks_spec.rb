require 'rails_helper'

RSpec.describe 'Tasks', type: :request do
  let!(:project) { create(:project) }
  let!(:task) { create(:task, project_id: project.id) }
  let!(:user) { create(:user) }

  before do
    allow_any_instance_of(TasksController).to receive(:current_user).and_return(user)
  end

  describe 'GET /projects/:project_id/tasks' do
    let!(:new_task) { create(:task, title: 'New task', project_id: project.id) }
    let!(:in_progress_task) { create(:task, title: 'Task in progress', project_id: project.id, status: :in_progress) }

    context 'without filter by status' do
      it 'shows all tasks' do
        get project_tasks_path(project_id: project.id)
        expect(response).to have_http_status(200)
        expect(response.body).to include(task.title)
        expect(response.body).to include(new_task.title)
        expect(response.body).to include(in_progress_task.title)
      end
    end

    context 'with filter by status' do
      it 'shows all tasks with specific status' do
        get project_tasks_path(project_id: project.id, status: 'new')
        expect(response).to have_http_status(200)
        expect(response.body).to include(task.title)
        expect(response.body).to include(new_task.title)
        expect(response.body).to_not include(in_progress_task.title)
      end
    end
  end

  describe 'GET /projects/:project_id/tasks/:id' do
    it 'shows task' do
      get project_task_path(project_id: project.id, id: task.id)
      expect(response).to have_http_status(200)
      expect(response.body).to include(task.title)
    end
  end

  describe 'POST /projects/:project_id/tasks' do
    context 'with valid params' do
      let(:task_params) { { title: 'Task', description: 'The description of task.' } }

      it 'creates task' do
        expect do
          post "/projects/#{project.id}/tasks", params: { task: task_params }
        end.to change(Task, :count).by(1)
      end

      it 'returns status code 201' do
        post "/projects/#{project.id}/tasks", params: { task: task_params }
        expect(response).to have_http_status(201)
      end
    end

    context 'with invalid params' do
      let(:task_params) { { title: '', description: 'The description of task.' } }

      it 'does not create task' do
        expect do
          post "/projects/#{project.id}/tasks", params: { task: task_params }
        end.to_not change(Task, :count)
      end

      it 'returns status code 422' do
        post "/projects/#{project.id}/tasks", params: { task: task_params }
        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'PUT /projects/:project_id/tasks/:id' do
    context 'with valid params' do
      let(:task_params) { { title: 'other task title' } }

      it 'updates the task' do
        put "/projects/#{project.id}/tasks/#{task.id}", params: { task: task_params }
        task.reload
        expect(task.title).to eq(task_params[:title])
      end

      it 'returns status code 200' do
        put "/projects/#{project.id}/tasks/#{task.id}", params: { task: task_params }
        expect(response).to have_http_status(200)
      end
    end

    context 'with invalid params' do
      let(:task_params) { { title: '' } }

      it 'does not update the task' do
        original_title = task.title
        put "/projects/#{project.id}/tasks/#{task.id}", params: { task: task_params }
        task.reload
        expect(task.title).to eq(original_title)
      end

      it 'returns status code 422' do
        put "/projects/#{project.id}/tasks/#{task.id}", params: { task: task_params }
        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'DELETE /projects/:project_id/tasks/:id' do
    it 'deletes the task' do
      expect { delete "/projects/#{project.id}/tasks/#{task.id}" }.to change(Task, :count).by(-1)
    end
  end
end
