class CreateArticles < ActiveRecord::Migration[8.1]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :description
      t.text :body
      t.references :user, null: false, foreign_key: true
      t.string :slug

      t.timestamps
    end
    add_index :articles, :slug
  end
end
