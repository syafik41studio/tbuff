class Devise::PasswordController < Devise::PasswordsController
  
  prepend_before_filter :require_no_authentication

  # GET /resource/password/new
  def new
    build_resource({})
  end

  # POST /resource/password
  def create
    self.resource = resource_class.send_reset_password_instructions(params[resource_name])
    
    if successfully_sent?(resource)
      respond_with({}, :location => after_sending_reset_password_instructions_path_for(resource_name))
    else
      respond_with(resource)
      flash[:error] = t("devise.registrations.email_blank")
    end
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  def edit
    self.resource = resource_class.new
    resource.reset_password_token = params[:reset_password_token]
  end

  # PUT /resource/password
  def update
    self.resource = resource_class.reset_password_by_token(params[resource_name])
    
    if resource.errors.empty?
      flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
      set_flash_message(:notice, flash_message) if is_navigational_format?
      sign_in(resource_name, resource)
      respond_with resource, :location => after_sign_in_path_for(resource)
    else
      if request.xhr?
        flash[:error] = "Your password unsuccessfully updated."
        render :update do |page|
          page.redirect_to :back
        end
      else
        respond_with resource, :error => "Some errors were found, please take a look:"
        flash[:error] = "Some errors were found, please take a look:"
      end
    end
  end

  protected

  # The path used after sending reset password instructions
  def after_sending_reset_password_instructions_path_for(resource_name)
    new_session_path(resource_name)
  end

end