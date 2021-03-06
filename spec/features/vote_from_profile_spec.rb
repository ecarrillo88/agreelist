require 'spec_helper'

feature 'voting', js: true do
  attr_reader :statement

  before do
    seed_data
  end

  context 'non logged user' do
    it "should invite to log in" do
      visit "/#{@individual.to_param}"
      expect(page).to have_content "Log in to add an opinion from #{@individual.name}"
    end
  end

  context 'logged user' do
    it "should add opinion" do
      login
      visit individual_path(@individual)
      fill_in :content, with: "climate change is real"
      fill_in :reason, with: "most scientists agree"
      fill_in :url, with: "http://whatever.com"
      expect{ click_button "She/he disagrees" }.to change{ Agreement.count }.by(1)
      a = Agreement.last
      expect(a.statement.content).to eq "climate change is real"
      expect(a.reason).to eq "most scientists agree"
      expect(a.url).to eq "http://whatever.com"
      expect(a.extent).to eq 0
    end
  end

  private

  def seed_data
    @statement = create(:statement)
    @individual = create(:individual, twitter: "someone")
    create(:agreement, statement: @statement, individual: @individual, extent: 100)
  end

  def login
    visit "/auth/twitter"
  end
end

