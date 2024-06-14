# frozen_string_literal: true

FactoryBot.define do
  factory :borrow do
    borrowed_at { Date.new(2024, 6, 13) }
    due_date { Date.new(2024, 6, 15) }
    book
    member factory: :user
  end
end
