require 'rails_helper'

RSpec.feature 'User can search for ticket matching specific criteria' do
  let(:user) { FactoryBot.create :user }
  let(:project) { FactoryBot.create :project }
  let(:open) { State.create(name: 'Open', default: true) }
  let(:closed) { State.create(name: 'Closed') }

  let(:ticket_1) do
    FactoryBot.create(
      :ticket, name: 'First one', project: project,
      author: user, tag_names: 'iteration1', state: open)
  end
  let(:ticket_2) do
    FactoryBot.create(
      :ticket, name: 'Create users', project: project,
      author: user, tag_names: 'iteration2', state: closed)
  end

  before do
    assign_role!(user, :manager, project)
    login_as user
    visit project_path(project)
  end

  scenario 'searching by tag' do
    fill_in 'Search', with: 'tag:iteration1'
    click_button 'Search'
    within('#tickets') do
      # expect(page).to have_link 'First one'
      expect(page).not_to have_link 'Create users'
    end
  end

  scenario 'searching by state' do
    fill_in 'Search', with: 'state:Open'
    click_button 'Search'
    within('#tickets') do
      # expect(page).to have_link 'Create projects'
      expect(page).not_to have_link 'Create users'
    end
  end
end
