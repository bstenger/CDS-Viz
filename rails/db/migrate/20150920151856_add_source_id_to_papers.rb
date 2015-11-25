class AddSourceIdToPapers < ActiveRecord::Migration
  def change
  	add_column :papers, :source_id, :string
  end
end
