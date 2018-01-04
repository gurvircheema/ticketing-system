require 'rails_helper'

RSpec.feature 'Users can create new tickets' do
  let(:author) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project) }
  let(:ticket) { FactoryBot.create(:ticket, project: project, author: author)}

  before do
    login_as(author)
    assign_role!(author, :editor, project)
    visit project_path(project)
    click_link 'New Ticket'
  end

  scenario 'with valid attributes' do
    fill_in 'Name', with: 'Non standard compilations'
    fill_in 'Description', with: 'My pages are ugly'
    click_button 'Create Ticket'
    expect(page).to have_content 'Ticket has been created.'
    within('#ticket') do
      expect(page).to have_content "Author: #{author.email}"
    end
  end

  scenario 'when providing invalid attributes' do
    click_button 'Create Ticket'
    expect(page).to have_content 'Ticket has not been created.'
    expect(page).to have_content "Name can't be blank"
    expect(page).to have_content "Description can't be blank"
  end

  scenario 'with an invalid description' do
    fill_in 'Name', with: 'No Compliance IE standards'
    fill_in 'Description', with: 'it sucks'
    click_button 'Create Ticket'
    expect(page).to have_content 'Ticket has not been created.'
    expect(page).to have_content 'Description is too short'
  end

  scenario 'with an attachment' do
    fill_in 'Name', with: 'Ticket screenshot'
    fill_in 'Description', with: 'Ticket with attachment'
    attach_file 'File', 'spec/fixtures/speed.txt'
    click_button 'Create Ticket'

    expect(page).to have_content 'Ticket has been created'
    within('#ticket .attachment') do
      expect(page).to have_content 'speed.txt'
    end
  end

  scenario 'persisting file uploads across the displays' do
    attach_file 'File', 'spec/fixtures/speed.txt'
    click_button 'Create Ticket'
    fill_in 'Name', with: 'Add attachment'
    fill_in 'Description', with: 'Add proper description'
    click_button 'Create Ticket'

    within('#ticket .attachment') do
      expect(page).to have_content 'speed.txt'
    end
  end
end
