class CreateAuthorsPapers < ActiveRecord::Migration
  def change
  	create_table :authors_papers, :id => false do |t|
  	  t.integer :author_id
  	  t.integer :paper_id
  	end
  end
end
