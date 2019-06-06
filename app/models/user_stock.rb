class UserStock < ApplicationRecord
  # Rails generated associations
  belongs_to :user
  belongs_to :stock
end
