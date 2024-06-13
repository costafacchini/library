FactoryBot.define do
  factory :user do
    name { 'John Doe' }
    email { 'admin@test.com' }
    password { '12345678' }
  end
end