FactoryBot.define do
  factory :friendship do
    user
    friend
  end

  factory :friend, parent: :user, class: 'Friend'
end
