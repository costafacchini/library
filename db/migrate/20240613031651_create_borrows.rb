# frozen_string_literal: true

class CreateBorrows < ActiveRecord::Migration[7.1]
  def change
    create_table :borrows do |t|
      t.date :borrowed_at
      t.date :returned_at
      t.date :due_date
      t.references :book, null: false, foreign_key: true
      t.references :member, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
