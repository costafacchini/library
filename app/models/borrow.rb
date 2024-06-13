class Borrow < ApplicationRecord
  validates :borrowed_at, presence: true
  validates :due_date, presence: true
  validates :member_id, presence: true
  validates :book_id, presence: true

  belongs_to :book
  belongs_to :member, class_name: 'User', foreign_key: :member_id

  before_validation :fill_due_date, on: :create
  validate :check_if_member_already_borrowed_the_book, on: :create
  validate :check_if_book_is_available, on: :create

  def overdue?(base_date)
    base_date > due_date
  end

  private

  def fill_due_date
    self.due_date = borrowed_at + 2.weeks if borrowed_at.present?
  end

  def check_if_member_already_borrowed_the_book
    errors.add(:member_id, :cannot_borrow_the_same_book_multiple_times) if has_borrowed_before?(member_id, book_id)
  end

  def has_borrowed_before?(member_id, book_id)
    Borrow.exists?(member_id: member_id, book_id: book_id)
  end

  def check_if_book_is_available
    errors.add(:book_id, :cannot_borrow_a_book_unavailable) unless book&.available?
  end
end
