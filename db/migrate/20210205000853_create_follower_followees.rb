class CreateFollowerFollowees < ActiveRecord::Migration[6.1]
  def change
    create_table :follower_followees do |t|
      t.integer :person_id
      t.integer :follower_id

      t.timestamps
    end
  end
end
