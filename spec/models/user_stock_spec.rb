require 'rails_helper'

RSpec.describe UserStock, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:stock) }
end
