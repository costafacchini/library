# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Borrow do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:borrowed_at) }
    it { is_expected.to validate_presence_of(:due_date) }
  end

  describe '#member_id' do
    it { is_expected.to belong_to(:member).class_name('User') }

    it 'does not add a validation error if the member never borrowed the book before' do
      borrow = build(:borrow)

      borrow.validate

      expect(borrow.errors[:member_id]).not_to include 'You cannot borrow the same book multiple times'
    end

    it 'adds a validation error if the member already borrowed the book before' do
      book = create(:book)
      member = create(:user, role: :member)
      create(:borrow, book:, member:)

      borrow = build(:borrow, book:, member:)

      borrow.validate

      expect(borrow.errors[:member_id]).to include 'You cannot borrow the same book multiple times'
    end
  end

  describe '#book_id' do
    it { is_expected.to belong_to(:book) }

    it 'does not add a validation error if the book is available' do
      book = create(:book)
      create(:borrow, book:, returned_at: Date.new(2024, 6, 13))

      borrow = build(:borrow, book:)

      borrow.validate

      expect(borrow.errors[:book_id]).not_to include 'You cannot borrow a book unavailable'
    end

    it 'adds a validation error if the member already borrowed the book before' do
      book = create(:book)
      create(:borrow, book:, returned_at: nil)

      borrow = build(:borrow, book:)

      borrow.validate

      expect(borrow.errors[:book_id]).to include 'You cannot borrow a book unavailable'
    end
  end

  describe '#overdue?' do
    subject(:borrow) { build(:borrow, due_date: Date.new(2024, 6, 15)) }

    it 'is overdue if the base date is greater than the due date' do
      expect(borrow.overdue?(Date.new(2024, 6, 16))).to be true
    end

    it 'is not overdue if the base date is equal than the due date' do
      expect(borrow.overdue?(Date.new(2024, 6, 15))).to be false
    end

    it 'is not overdue if the base date is less than the due date' do
      expect(borrow.overdue?(Date.new(2024, 6, 14))).to be false
    end
  end

  describe 'before validation' do
    subject(:borrow) { build(:borrow, borrowed_at: Date.new(2024, 6, 13)) }

    it 'fills the due date 2 weeks ahead' do
      borrow.valid?
      expect(borrow.due_date).to eq(Date.new(2024, 6, 27))
    end
  end
end
