class Employment < ApplicationRecord
  belongs_to :farm
  belongs_to :user
end
