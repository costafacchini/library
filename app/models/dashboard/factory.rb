# frozen_string_literal: true

class Dashboard::Factory
  def self.create(user)
    klass = Dashboard.const_get(user.role.capitalize)

    klass.new
  end
end
