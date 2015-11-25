require 'rails_helper'

RSpec.describe "authors/new", :type => :view do
  before(:each) do
    assign(:author, Author.new(
      :name => "MyString",
      :first => "MyString",
      :middle => "MyString",
      :last => "MyString"
    ))
  end

  it "renders new author form" do
    render

    assert_select "form[action=?][method=?]", authors_path, "post" do

      assert_select "input#author_name[name=?]", "author[name]"

      assert_select "input#author_first[name=?]", "author[first]"

      assert_select "input#author_middle[name=?]", "author[middle]"

      assert_select "input#author_last[name=?]", "author[last]"
    end
  end
end
