ActiveAdmin.register User do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name, :email, :gender, :userable_type, :userable_id, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at
  #
  # or
  #
  permit_params do
    permitted = [:name, :email, :gender, :userable_type, :userable_id, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at]
    permitted << :other if params[:action] == 'create' && current_user.admin?
    permitted
  end
  index do
    selectable_column
    id_column
    column :name do |model|
      userable_type = model.userable_type
      userable_id = model.userable_id
      if userable_type.present? && userable_id.present?
        userable = userable_type.constantize.find(userable_id)
        link_to model.name, polymorphic_path([:admin, userable])
      else
        "No userable associated"
      end
    end
    column :email
    column :gender
    column "User Type" do |model|
      model.userable_type
    end
    column :reset_password_token
    column :reset_password_sent_at
  end 
end
