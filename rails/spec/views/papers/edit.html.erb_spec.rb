require 'rails_helper'

RSpec.describe "papers/edit", :type => :view do
  before(:each) do
    @paper = assign(:paper, Paper.create!(
      :title => "MyString",
      :version => ""
    ))
  end

  it "renders the edit paper form" do
    render

    assert_select "form[action=?][method=?]", paper_path(@paper), "post" do

      assert_select "input#paper_title[name=?]", "paper[title]"

      assert_select "input#paper_version[name=?]", "paper[version]"
    end
  end
end
