require 'rails_helper'

RSpec.describe 'Projects', type: :request do
  let!(:project) { create(:project) }
  let!(:user) { create(:user) }

  before do
    allow_any_instance_of(ProjectsController).to receive(:current_user).and_return(user)
  end

  describe 'GET /projects' do
    let!(:other_project) { create(:project, title: 'Some other project') }
    let!(:task) { create(:task, project_id: project.id) }

    it 'shows all projects with their tasks' do
      get projects_path, as: :json
      expect(response).to have_http_status(200)
      expect(response.body).to include(project.title)
      expect(response.body).to include(other_project.title)
      expect(response.body).to include(task.title)
    end
  end

  describe 'GET /projects/:id' do
    it 'shows project with its tasks' do
      get project_path(project), as: :json
      expect(response).to have_http_status(200)
      expect(response.body).to include(project.title)
    end
  end

  describe 'POST /projects' do
    context 'with valid params' do
      let(:project_params) { { title: 'Project', description: 'The description of project.' } }

      it 'creates project' do
        expect { post '/projects', params: { project: project_params } }.to change(Project, :count).by(1)
      end

      it 'returns status code 201' do
        post '/projects', params: { project: project_params }
        expect(response).to have_http_status(201)
      end
    end

    context 'with invalid params' do
      let(:project_params) { { title: '', description: 'The description of project.' } }

      it 'does not create project' do
        expect { post '/projects', params: { project: project_params } }.to_not change(Project, :count)
      end

      it 'returns status code 422' do
        post '/projects', params: { project: project_params }
        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'PUT /projects/:id' do
    context 'with valid params' do
      let(:project_params) { { title: 'other project title' } }

      it 'updates the project' do
        put "/projects/#{project.id}", params: { project: project_params }
        project.reload
        expect(project.title).to eq(project_params[:title])
      end

      it 'returns status code 200' do
        put "/projects/#{project.id}", params: { project: project_params }
        expect(response).to have_http_status(200)
      end
    end

    context 'with invalid params' do
      let(:project_params) { { title: '' } }

      it 'does not update the project' do
        original_title = project.title
        put "/projects/#{project.id}", params: { project: project_params }
        project.reload
        expect(project.title).to eq(original_title)
      end

      it 'returns status code 422' do
        put "/projects/#{project.id}", params: { project: project_params }
        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'DELETE /projects/:id' do
    it 'deletes the project' do
      expect { delete "/projects/#{project.id}" }.to change(Project, :count).by(-1)
    end
  end
end
