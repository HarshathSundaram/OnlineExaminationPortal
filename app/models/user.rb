class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
    belongs_to :userable, polymorphic: true

  scope :student, ->{User.where("userable_type = ?","Student")}
  scope :instructor, ->{User.where("userable_type = ?","Instructor")}
end
