class AddElsevierIdToAuthors < ActiveRecord::Migration
  def change
    add_column :authors, :elsevier_id, :integer
  end
end
