require 'rails_helper'

RSpec.feature 'Users can only see the appropriate links' do
  let(:user) { FactoryBot.create(:user) }
  let(:admin) { FactoryBot.create(:user, :admin, email: 'admin@gmail.com') }
  let(:project) { FactoryBot.create(:project) }
  let(:ticket) { FactoryBot.create(:ticket, project: project, author: user)}

  before do
    login_as(user)
    assign_role!(user, :viewer, project)
  end

  context 'anonymous users' do
    scenario 'cannot the see the New Project link' do
      visit '/'
      expect(page).not_to have_link 'New Project'
    end

    scenario "cannot see the Delete Project link" do
      visit project_path(project)
      expect(page).not_to have_link "Delete Project"
    end
  end

  context 'regular users (non-admins, viewers' do
    before do
      login_as(user)
    end

    scenario 'cannot see the new project link' do
      visit '/'
      expect(page).not_to have_link 'New Project'
    end

    scenario 'cannot see the edit project link' do
      visit project_path(project)
      expect(page).not_to have_link 'Edit Project'
    end

    scenario 'cannot see the new ticket link' do
      visit project_path(project)
      expect(page).not_to have_link 'New Ticket'
    end

    scenario 'cannot see the edit ticket link' do
      visit project_ticket_path(project, ticket)
      expect(page).not_to have_link 'Edit Ticket'
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

    scenario 'can see the edit project link' do
      visit project_path(project)
      expect(page).to have_link 'Edit Project'
    end

    scenario 'can see the new ticket link' do
      visit project_path(project)
      expect(page).to have_link 'New Ticket'
    end

    scenario 'can see the edit ticket link' do
      visit project_ticket_path(project, ticket)
      expect(page).to have_link 'Edit Ticket'
    end
  end
end
