# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Dashboard do
  describe 'dashboard routing' do
    it 'routes to index' do
      assert_generates 'v1/users', { controller: 'v1/users', action: 'index' }
    end

    it 'does not route to update' do
      expect(patch: 'v1/dashboard/1').not_to route_to(controller: 'v1/dashboard', action: 'update', id: 1)
    end

    it 'does not route to create' do
      expect(post: 'v1/users').not_to route_to(controller: 'v1/users', action: 'create')
    end

    it 'does not route to show' do
      expect(get: 'v1/users/1').not_to route_to(controller: 'v1/users', action: 'show', id: 1)
    end

    it 'does not route to destroy' do
      expect(delete: 'v1/users/1').not_to route_to(controller: 'v1/users', action: 'destroy', id: 1)
    end
  end
end
