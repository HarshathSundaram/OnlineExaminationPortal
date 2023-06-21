# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  #before_action :configure_sign_up_params, only: [:create]
  #before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    userable = if params[:role][:role]=="Student"
        Student.new(student_params)
    elsif params[:role][:role]=="Instructor"
      Instructor.new(instructor_params)
    end
    if userable.valid?
      userable.save
      puts userable.id
      user = user_params
      build_resource(sign_up_params)
      resource.name = user[:name]
      resource.gender = user[:gender]
      resource.userable_type = params[:role][:role].camelcase
      resource.userable_id = userable.id
      resource.save
    
      # ...
    else
        p userable.error
    end

    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  def after_sign_up_path_for(resource)
    if resource.userable_type == "Student"
      student_path(resource.userable_id)
    elsif resource.userable_type == "Instructor"
      instructor_path(resource.userable_id)
    end
  end
  

  private
    def student_params
      params.require(:student_attributes).permit(:department,:year)
    end
    def instructor_params
      params.require(:instructor_attributes).permit(:designation)
    end
    def user_params
      params.require(:user).permit(:name, :gender)
    end
    def role_params
      params.require(:role).permit(:role)
    end
  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
