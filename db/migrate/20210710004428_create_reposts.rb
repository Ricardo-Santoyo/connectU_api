class CreateReposts < ActiveRecord::Migration[6.1]
  def change
    create_table :reposts do |t|
      t.integer :user_id
      t.references :repostable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
