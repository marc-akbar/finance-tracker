require 'rails_helper'

RSpec.describe User, type: :model do
  subject { create(:user) }

  describe '#full_name' do
    it "returns the user's full name" do
      user = create(:user, first_name: 'Harry', last_name: 'Potter')

      expect(user.full_name).to eq('Harry Potter')
    end

    it 'returns anonymous when no name' do
      user = create(:user, first_name: nil, last_name: nil)

      expect(user.full_name).to eq('Anonymous')
    end
  end

  describe '#stock_already_added?' do
    it 'returns false when the stock does not exist' do
      expect(subject.stock_already_added?('TSLA')).to eq(false)
    end

    it 'returns true when the stock exists' do
      stock = create(:stock, ticker: 'TSLA')
      create(:user_stock, user: subject, stock: stock)

      expect(subject.stock_already_added?('TSLA')).to eq(true)
    end
  end

  describe '#under_stock_limit' do
    it 'returns true when under 15' do
      14.times { create(:user_stock, user: subject) }

      expect(subject.under_stock_limit?).to eq(true)
    end

    it 'returns false when 15 or over' do
      15.times { create(:user_stock, user: subject) }

      expect(subject.under_stock_limit?).to eq(false)
    end
  end

  describe '#can_add_stock?' do
    it 'can add when under limit and not already added' do
      stock = create(:stock, ticker: 'GOOG')
      14.times { create(:user_stock, user: subject, stock: stock) }

      expect(subject.can_add_stock?('AAPL')).to be(true)
    end

    it 'cannot add when over limit' do
      15.times { create(:user_stock, user: subject) }

      expect(subject.can_add_stock?('GOOG')).to be(false)
    end

    it 'cannot add when already added' do
      stock = create(:stock, ticker: 'TSLA')
      create(:user_stock, user: subject, stock: stock)

      expect(subject.can_add_stock?('TSLA')).to be(false)
    end
  end

  describe '.search' do
    it 'matches user by info' do
      harry = create(:user, first_name: 'Harry', last_name: 'Potter',
                            email: 'hogwarts@example.com')
      ron = create(:user, first_name: 'Ron', last_name: 'Weasley',
                          email: 'griff@example.com')

      expect(User.first_name_matches('harry')).to eq([harry])
      expect(User.last_name_matches('Wea')).to eq([ron])
      expect(User.email_matches('@')).to eq([harry, ron])
      expect(User.search('@')).to eq([harry, ron])
    end
  end

  describe '#except_current_user' do
    it 'omits the current user' do
      current_user = create(:user, first_name: 'Harry')
      users = [create(:user), create(:user), current_user]

      expect(current_user.except_current_user(users))
        .not_to include(current_user)
    end
  end

  describe '#not_friends_with?' do
    it 'is false when currently friends' do
      friend = create(:user, first_name: 'Harry')
      create(:friendship, user: subject, friend: friend)

      expect(subject.not_friends_with?(friend)).to be(false)
    end

    it 'is true when not currently friends' do
      not_friend = create(:user, first_name: 'Malfoy')

      expect(subject.not_friends_with?(not_friend)).to be(true)
    end
  end
end
