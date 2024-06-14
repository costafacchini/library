# frozen_string_literal: true

class AddSearchToBooks < ActiveRecord::Migration[7.1]
  def change
    add_column :books, :search, :string
  end
end
