require 'rails_helper'

RSpec.describe "papers/show", :type => :view do
  before(:each) do
    @paper = assign(:paper, Paper.create!(
      :title => "Title",
      :version => ""
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(//)
  end
end
