require 'rails_helper'

RSpec.feature 'Users can create new tickets' do
  let(:state) { FactoryBot.create :state, name: 'New', default: true }
  let(:author) { FactoryBot.create(:user) }

  before do
    login_as(author)
    project = FactoryBot.create(:project, name: 'IE')
    assign_role!(author, :manager, project)

    visit project_path(project)
    click_link 'New Ticket'
  end

  scenario 'with valid attributes' do
    fill_in 'Name', with: 'Non-standards compliance'
    fill_in 'Description', with: 'My pages are ugly!'
    click_button 'Create Ticket'

    expect(page).to have_content 'Ticket has been created.'
    # expect(page).to have_content 'State: New'
    within("#ticket") do
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

  scenario 'persisting file uploads across the displays' do
    attach_file 'File #1', 'spec/fixtures/speed.txt'
    # click_button 'Create Ticket'
    fill_in 'Name', with: 'Add attachment'
    fill_in 'Description', with: 'Add proper description'
    click_button 'Create Ticket'

    within("#ticket .attachments") do
      expect(page).to have_content 'speed.txt'
    end
  end

  scenario "with multiple attachments", js: true do
    fill_in "Name", with: "Add documentation for blink tag"
    fill_in "Description", with: "Blink tag's speed attribute"

    click_link "Add another file"
    attach_file "File #1", Rails.root.join("spec/fixtures/speed.txt")
    click_link "Add another file"

    attach_file "File #2", Rails.root.join("spec/fixtures/spin.txt")
    click_button "Create Ticket"

    expect(page).to have_content "Ticket has been created."

    within("#ticket .attachments") do
      expect(page).to have_content "speed.txt"
      expect(page).to have_content "spin.txt"
    end
  end

  scenario 'with associated tags' do
    fill_in 'Name', with: 'Tag Ticket'
    fill_in 'Description', with: 'Has many tags'
    fill_in 'Tags', with: 'tagged experiment'
    click_button 'Create Ticket'

    expect(page).to have_content 'Ticket has been created'
    within('#ticket #tags') do
      expect(page).to have_content 'tagged'
      expect(page).to have_content 'experiment'
    end
  end
end
