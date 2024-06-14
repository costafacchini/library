# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Book do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:author) }
    it { is_expected.to validate_presence_of(:genre) }
  end

  describe '#borrows' do
    it { is_expected.to have_many(:borrows).dependent(:destroy) }
  end

  describe '#available?' do
    it 'returns true if there is no borrow in progress' do
      book = create(:book)
      create(:borrow, book:, returned_at: Date.new(2024, 6, 13))

      expect(book.available?).to be true
    end

    it 'returns false if there a borrow in progress' do
      book = create(:book)
      create(:borrow, book:, returned_at: nil)

      expect(book.available?).to be false
    end
  end

  describe '.by_expression' do
    let!(:to_kill_mockingbird) { create(:book, title: 'To Kill Mockingbird', author: 'Harper-Lee', genre: 'Novel') }
    let!(:ikigai) do
      create(:book, title: 'Ikigai: The Japanese Secret to a Long and Happy Life', author: 'Héctor García',
                    genre: 'Personal Development')
    end

    describe 'matching title' do
      it 'returns an array of results that match' do
        expect(described_class.by_expression('To').order(:id)).to eq [to_kill_mockingbird, ikigai]
      end
    end

    describe 'matching title with two words' do
      it 'returns an array of results that match' do
        expect(described_class.by_expression('to Kill')).to eq [to_kill_mockingbird]
      end
    end

    describe 'matching title in random order' do
      it 'returns an array of results that match' do
        expect(described_class.by_expression('long sec')).to eq [ikigai]
      end
    end

    describe 'matching author' do
      it 'returns an array of results that match' do
        expect(described_class.by_expression('Harper lee')).to eq [to_kill_mockingbird]
      end
    end

    describe 'matching genre' do
      it 'returns an array of results that match' do
        expect(described_class.by_expression('Personal')).to eq [ikigai]
      end
    end

    describe 'matching all' do
      it 'returns an array of results that match' do
        expect(described_class.by_expression('').order(:id)).to eq [to_kill_mockingbird, ikigai]
      end
    end

    context 'when nothing matches' do
      it 'returns an empty array' do
        expect(described_class.by_expression('Another book')).to eq []
      end
    end
  end

  describe 'before save' do
    subject(:book) { create(:book, title: 'To Kill a/Mockingbird 1.2-3/4', author: 'Harper-Lee', genre: 'Novel') }

    it 'fills the search attribute with name in downcase and without special characters' do
      expect(book.search).to eq(',to,kill,amockingbird,a,mockingbird,1234,harperlee,harper,lee,novel')
    end
  end
end
