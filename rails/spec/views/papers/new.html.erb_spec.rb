require 'rails_helper'

RSpec.describe "papers/new", :type => :view do
  before(:each) do
    assign(:paper, Paper.new(
      :title => "MyString",
      :version => ""
    ))
  end

  it "renders new paper form" do
    render

    assert_select "form[action=?][method=?]", papers_path, "post" do

      assert_select "input#paper_title[name=?]", "paper[title]"

      assert_select "input#paper_version[name=?]", "paper[version]"
    end
  end
end
