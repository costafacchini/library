# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Borrow do
  describe 'borrow routing' do
    it 'routes to create' do
      assert_generates 'v1/borrows', { controller: 'v1/borrows', action: 'create' }
    end

    it 'does not route to index' do
      expect(get: 'v1/borrows').not_to route_to(controller: 'v1/borrows', action: 'index')
    end

    it 'does not route to show' do
      expect(get: 'v1/borrows/1').not_to route_to(controller: 'v1/borrows', action: 'show', id: 1)
    end

    it 'does not route to update' do
      expect(patch: 'v1/borrows/1').not_to route_to(controller: 'v1/borrows', action: 'update', id: 1)
    end

    it 'does not route to destroy' do
      expect(delete: 'v1/borrows/1').not_to route_to(controller: 'v1/borrows', action: 'destroy', id: 1)
    end
  end
end
