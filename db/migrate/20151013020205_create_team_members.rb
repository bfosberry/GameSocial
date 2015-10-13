class CreateTeamMembers < ActiveRecord::Migration
  def change
    create_table :team_members do |t|
        t.integer :team_id
        t.integer :user_id
    end
  end
end
