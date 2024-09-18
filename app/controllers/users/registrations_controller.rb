class Users::RegistrationsController < Devise::RegistrationsController
    before_action :configure_account_update_params, only: [ :update ]

    # Configure additional parameters for account updates
    def configure_account_update_params
        devise_parameter_sanitizer.permit(:account_update, keys: [ :email, :email, :email, :password, :password_confirmation, :current_password ])
    end

    # Redirect to the sign-in page after updating the profile
    def after_update_path_for(resource)
      sign_out(resource)
      new_user_session_path
    end
end
