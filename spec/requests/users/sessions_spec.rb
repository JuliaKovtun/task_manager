require 'rails_helper'

RSpec.describe 'Users::Sessions', type: :request do
  let!(:user) { create(:user) }

  describe 'POST /users/sign_in' do
    context 'with valid params' do
      it 'returns a successful response with token' do
        post user_session_path, params: { user: { email: user.email, password: 'password' } }
        expect(response).to have_http_status(:success)
        expect(response.body).to include('auth_token')
      end
    end

    context 'with invalid params' do
      it 'does not return a successful response' do
        post user_session_path, params: { user: { email: user.email, password: '' } }
        expect(response).to_not have_http_status(:success)
      end
    end
  end
end
