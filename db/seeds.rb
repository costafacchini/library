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
# Create a default user as a Admin
User.create!(name: 'Member', email: 'member@test.com', password: 'member123', role: :member)

# Create some default books for demo
Book.new(title: 'To Kill a Mockingbird', author: 'Harper Lee', genre: 'Novel', isbn: '9780061120084',
         total_copies: 40_000_000).save!
Book.new(title: 'Ikigai: The Japanese Secret to a Long and Happy Life', author: 'Héctor García',
         genre: 'Personal Development', isbn: '9788543108946', total_copies: 100_000_000).save!
Book.new(title: 'Clean Code: A Handbook of Agile Software Craftsmanship', author: 'Robert C. Martin',
         genre: 'Technology Programming Software Development', isbn: '9780132350884', total_copies: 1_000_000).save!
Book.new(title: 'It', author: 'Stephen King', genre: 'Horror Thriller', isbn: '9781501148911',
         total_copies: 30_000_000).save!
Book.new(title: 'Head First Design Patterns', author: 'Eric Freeman, Elisabeth Robson, Bert Bates, Kathy Sierra',
         genre: 'Technology / Software Development / Design Patterns', isbn: '9780596007126', total_copies: 500_000).save!
Book.new(title: 'The Very Hungry Caterpillar', author: 'Eric Carle', genre: "Children's Literature Picture Book",
         isbn: '9780399226908', total_copies: 50_000_000).save!

# Create some default borrows for demo
Borrow.new(member: User.find_by_name('Member'), book: Book.find_by_title('To Kill a Mockingbird'), borrowed_at: Date.new(2024, 5, 1),
           returned_at: Date.new(2024, 5, 10)).save!
Borrow.new(member: User.find_by_name('Member'), book: Book.find_by_title('It'), borrowed_at: Date.new(2024, 5, 22)).save!
Borrow.new(member: User.find_by_name('Member'), book: Book.find_by_title('Clean Code: A Handbook of Agile Software Craftsmanship'),
           borrowed_at: Date.new(2024, 5, 31)).save!
