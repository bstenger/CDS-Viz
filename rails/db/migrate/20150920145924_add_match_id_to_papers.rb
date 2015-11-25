class AddMatchIdToPapers < ActiveRecord::Migration
  def change
  	add_column :papers, :match_id, :integer
  end
end
