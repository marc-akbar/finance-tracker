class Friendship < ApplicationRecord
  belongs_to :user
  # Friend has no class so we define it
  belongs_to :friend, :class_name => 'User'


end
