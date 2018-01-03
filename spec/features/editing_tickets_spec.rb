require 'rails_helper'

RSpec.feature 'User can edit existing tickets' do
  let(:author) { FactoryBot.create(:user) }
  let!(:project) { FactoryBot.create(:project) }
  let(:ticket) { FactoryBot.create(:ticket, project: project, author: author) }

  before do
    login_as(author)
    assign_role!(author, :editor, project)
    visit project_ticket_path(project, ticket)
    click_link 'Edit Ticket'
  end

  scenario 'with valid attributes' do
    fill_in 'Name', with: 'Make it better'
    fill_in 'Description', with: 'Adding a new description'
    click_button 'Update Ticket'

    expect(page).to have_content 'Ticket has been updated'

    within('#ticket h2') do
      expect(page).to have_content 'Make it better'
      expect(page).to_not have_content ticket.name
    end
  end

  scenario 'with invalid attributes' do
    fill_in 'Name', with: ''
    click_button 'Update Ticket'
    expect(page).to have_content 'Ticket has not been updated.'
  end
end
