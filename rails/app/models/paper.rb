class Paper < ActiveRecord::Base
  attr_accessible :pub_date, :title, :archive, :version, :authors
  has_and_belongs_to_many :authors
  has_one :matchedPaper, :class_name => "Paper", :foreign_key => "match_id"
  belongs_to :match, :class_name => "Paper"
#  self.include_root_in_json = false
end
