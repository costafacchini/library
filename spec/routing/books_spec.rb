require 'rails_helper'

RSpec.describe Book, type: :routing do
  describe 'books routing' do
    it 'routes to index (root)' do
      assert_generates 'v1/books', { controller: 'v1/books', action: 'index' }
    end

    it 'routes to show' do
      assert_generates 'v1/books/1', { controller: 'v1/books', action: 'show', id: '1' }
    end

    it 'routes to create' do
      assert_generates 'v1/books', { controller: 'v1/books', action: 'create' }
    end

    it 'routes to update' do
      assert_generates 'v1/books/1', { controller: 'v1/books', action: 'update', id: '1' }
    end

    it 'routes to destroy' do
      assert_generates 'v1/books/1', { controller: 'v1/books', action: 'destroy', id: '1' }
    end
  end
end