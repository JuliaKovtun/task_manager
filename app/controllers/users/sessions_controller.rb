# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    def create
      self.resource = warden.authenticate!(auth_options)
      sign_in(resource_name, resource)
      respond_with_authentication_token(resource)
    end

    protected

    def respond_with_authentication_token(resource)
      render json: {
        success: true,
        auth_token: resource.authentication_token,
        email: resource.email
      }
    end
  end
end
