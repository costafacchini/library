require 'rails_helper'

RSpec.describe BooksQuery do
  describe '#call' do
    it 'returns a list of books' do
      book = create(:book)

      expect(subject.call).to eq [book]
    end

    it 'returns the books list sorted by #title' do
      book_d = create(:book, title: 'd book', id: 20)
      book_b = create(:book, title: 'b book', id: 10)
      book_a = create(:book, title: 'a book', id: 40)
      book_c = create(:book, title: 'c book', id: 30)

      results = subject.call
      expect(results).to eq [book_a, book_b, book_c, book_d]
    end
  end

  describe '#by_expression' do
    it 'prepares #call to result a list of books filtered by expression' do
      book_a = create(:book, title: 'a book')
      book_b = create(:book, title: 'b book')
      book_ab = create(:book, title: 'ab book')

      expect(Book).to receive(:by_expression)
        .with('a').and_call_original

      query = described_class.new
      result = query.by_expression('a').call

      expect(result).not_to include book_b
      expect(result).to eq [book_a, book_ab]
    end

    it 'returns self' do
      query = described_class.new
      expect(query.by_expression(nil)).to eq query
    end
  end
end
