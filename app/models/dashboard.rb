# frozen_string_literal: true

class Dashboard
  attr_accessor :data

  def initialize(user, today)
    self.data = Dashboard::Factory.create(user)
    data.load(user, today)
  end
end
