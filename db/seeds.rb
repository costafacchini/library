# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create a default user as a Admin
User.create!(name: 'Admin', email: 'admin@test.com', password: '12345678', role: :librarian)

# Create some default books for demo
Book.new(title: 'To Kill a Mockingbird', author: 'Harper Lee', genre: 'Novel', isbn: '9780061120084',
         total_copies: 40_000_000).save!
Book.new(title: 'Ikigai: The Japanese Secret to a Long and Happy Life', author: 'Héctor García',
         genre: 'Personal Development', isbn: '9788543108946', total_copies: 100_000_000).save!
