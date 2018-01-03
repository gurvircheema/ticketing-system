require 'rails_helper'

RSpec.feature 'Users can only see the appropriate links' do
  let(:user) { FactoryBot.create(:user) }
  let(:admin) { FactoryBot.create(:user, :admin) }
  let(:project) { FactoryBot.create(:project) }

  context 'anonymouse users' do
    scenario 'cannot the see the New p=Project link' do
      visit '/'
      expect(page).not_to have_link 'New Project'
    end

    scenario "cannot see the Delete Project link" do
      visit project_path(project)
      expect(page).not_to have_link "Delete Project"
    end

    scenario "cannot see the Delete Project link" do
      visit project_path(project)
      expect(page).not_to have_link "Delete Project"
    end
  end

  context 'regular users' do
    before do
      login_as(user)
    end

    scenario 'cannot see the new project link' do
      visit '/'
      expect(page).not_to have_link 'New Project'
    end
  end

  context 'Admin users' do
    before do
      login_as(admin)
    end

    scenario 'can see the New Project link' do
      visit '/'
      expect(page).to have_link 'New Project'
    end

    scenario "can see the Delete Project link" do
      visit project_path(project)
      expect(page).to have_link "Delete Project"
    end
  end
end
