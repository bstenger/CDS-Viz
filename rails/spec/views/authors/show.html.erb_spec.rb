require 'rails_helper'

RSpec.describe "authors/show", :type => :view do
  before(:each) do
    @author = assign(:author, Author.create!(
      :name => "Name",
      :first => "First",
      :middle => "Middle",
      :last => "Last"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/First/)
    expect(rendered).to match(/Middle/)
    expect(rendered).to match(/Last/)
  end
end
