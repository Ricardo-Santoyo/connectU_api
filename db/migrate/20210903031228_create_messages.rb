class CreateMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :messages do |t|
      t.text :body
      t.integer :sender_id
      t.integer :receiver_id
      t.timestamps
    end
  end
end
