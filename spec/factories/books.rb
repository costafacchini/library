# frozen_string_literal: true

FactoryBot.define do
  factory :book do
    title { 'To Kill a Mockingbird' }
    author { 'Harper Lee' }
    genre { 'Novel' }
    isbn { '9780061120084' }
    total_copies { 40_000_000 }
  end
end
