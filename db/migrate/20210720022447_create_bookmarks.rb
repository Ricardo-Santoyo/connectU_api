class CreateBookmarks < ActiveRecord::Migration[6.1]
  def change
    create_table :bookmarks do |t|
      t.integer :user_id
      t.references :bookmarkable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
