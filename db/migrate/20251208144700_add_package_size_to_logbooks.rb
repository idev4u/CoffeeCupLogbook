class AddPackageSizeToLogbooks < ActiveRecord::Migration[7.1]
  def change
    add_column :logbooks, :package_size_grams, :integer
  end
end