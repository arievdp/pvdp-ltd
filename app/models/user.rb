class User < ApplicationRecord
has_person_name
hasm_many :employments
has_many :farms, through: :employments

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
