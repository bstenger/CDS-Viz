class Author < ActiveRecord::Base
  attr_accessible :first, :last, :middle, :name, :elsevier_id
  has_and_belongs_to_many :papers
end
