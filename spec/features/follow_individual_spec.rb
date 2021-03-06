require 'spec_helper'

feature "follow_individual", js: true do
  before do
    seed_data
    login
  end

  scenario "should change button to following and back again" do
    visit individual_path(@individual)
    expect{ click_link "Follow" }.to change{ Follow.count }.by(1)
    expect(page).to have_content "Following"
    expect{ click_link "Following" }.to change{ Follow.count }.by(-1)
    expect(page).to have_content "Follow"
  end

  def seed_data
    create(:statement)
    @individual = create(:individual)
  end

  def login
    visit root_path
    visit "/auth/twitter"
  end
end
