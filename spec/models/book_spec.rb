require 'rails_helper'

RSpec.describe Book, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:author) }
    it { should validate_presence_of(:genre) }
  end

  describe '.by_expression' do
    let!(:book1) { create(:book, title: 'To Kill Mockingbird', author: 'Harper-Lee', genre: 'Novel') }
    let!(:book2) { create(:book, title: 'Ikigai: The Japanese Secret to a Long and Happy Life', author: 'Héctor García', genre: 'Personal Development') }

    context 'matching title' do
      it 'returns an array of results that match' do
        expect(Book.by_expression('To').order(:id)).to eq [book1, book2]
      end
    end

    context 'matching title with two words' do
      it 'returns an array of results that match' do
        expect(Book.by_expression('to Kill')).to eq [book1]
      end
    end

    context 'matching title in random order' do
      it 'returns an array of results that match' do
        expect(Book.by_expression('long sec')).to eq [book2]
      end
    end

    context 'matching title with two words' do
      it 'returns an array of results that match' do
        expect(Book.by_expression('to Kill')).to eq [book1]
      end
    end

    context 'matching title in random order' do
      it 'returns an array of results that match' do
        expect(Book.by_expression('long sec')).to eq [book2]
      end
    end

    context 'matching author' do
      it 'returns an array of results that match' do
        expect(Book.by_expression('Harper lee')).to eq [book1]
      end
    end

    context 'matching genre' do
      it 'returns an array of results that match' do
        expect(Book.by_expression('Personal')).to eq [book2]
      end
    end

    context 'matching all' do
      it 'returns an array of results that match' do
        expect(Book.by_expression('').order(:id)).to eq [book1, book2]
      end
    end

    context 'when nothing matches' do
      it 'returns an empty array' do
        expect(Book.by_expression('Another book')).to eq []
      end
    end
  end

  describe 'before save' do
    subject { create(:book, title: 'To Kill a/Mockingbird 1.2-3/4', author: 'Harper-Lee', genre: 'Novel') }

    it 'fills the search attribute with name in downcase and without special characters' do
      expect(subject.search).to eq(',to,kill,amockingbird,a,mockingbird,1234,harperlee,harper,lee,novel')
    end
  end
end
