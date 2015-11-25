require 'rails_helper'

RSpec.describe "papers/index", :type => :view do
  before(:each) do
    assign(:papers, [
      Paper.create!(
        :title => "Title",
        :version => ""
      ),
      Paper.create!(
        :title => "Title",
        :version => ""
      )
    ])
  end

  it "renders a list of papers" do
    render
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
