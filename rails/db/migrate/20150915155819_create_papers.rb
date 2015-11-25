class CreatePapers < ActiveRecord::Migration
  def change
    create_table :papers do |t|
      t.string :archive
      t.string :title
      t.datetime :pub_date
      t.integer :version

      t.timestamps
    end
  end
end
