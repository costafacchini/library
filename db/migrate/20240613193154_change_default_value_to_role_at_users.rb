class ChangeDefaultValueToRoleAtUsers < ActiveRecord::Migration[7.1]
  def change
    change_column_default :users, :role, from: nil, to: User.roles[:member]
  end
end
