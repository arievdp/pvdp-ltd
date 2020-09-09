class Farm < ApplicationRecord
  has_many :animals
  has_many :employments
  has_many :users, through: :employments
end
