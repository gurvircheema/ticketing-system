require 'rails_helper'

RSpec.feature 'Users can delete unwanted tags from a ticket' do
  let(:user) { FactoryBot.create :user }
  let(:project) { FactoryBot.create :project }
  let(:ticket) do
    FactoryBot.create(
      :ticket,
      project: project,
      tag_names: 'thisTagMustDie',
      author: user
    )
  end

  before do
    login_as user
    assign_role! user, :manager, project
    visit project_ticket_path(project, ticket)
  end

  scenario 'successfully', js: true do
    within tag('thisTagMustDie') do
      click_link 'remove'
    end
    expect(page).not_to have_content 'thisTagMustDie'
  end
end
