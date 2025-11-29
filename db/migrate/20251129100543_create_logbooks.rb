class CreateLogbooks < ActiveRecord::Migration[8.1]
  def change
    create_table :logbooks do |t|
      t.string :cup_type
      t.integer :amount

      t.timestamps
    end
  end
end
