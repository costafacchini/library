class Dashboard
  attr_accessor :data

  def initialize(user, today)
    self.data = Dashboard::Factory.create(user)
    self.data.load(user, today)
  end
end
