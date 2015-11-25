require 'rails_helper'

RSpec.describe "authors/index", :type => :view do
  before(:each) do
    assign(:authors, [
      Author.create!(
        :name => "Name",
        :first => "First",
        :middle => "Middle",
        :last => "Last"
      ),
      Author.create!(
        :name => "Name",
        :first => "First",
        :middle => "Middle",
        :last => "Last"
      )
    ])
  end

  it "renders a list of authors" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "First".to_s, :count => 2
    assert_select "tr>td", :text => "Middle".to_s, :count => 2
    assert_select "tr>td", :text => "Last".to_s, :count => 2
  end
end
