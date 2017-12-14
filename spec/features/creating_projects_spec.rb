require 'rails_helper'

RSpec.feature 'Users can create new projects' do
  before do
    visit '/'
    click_link 'New Project'
  end

  scenario 'with valid attributes' do
    fill_in 'Name', with: 'Sample Project'
    fill_in 'Description', with: 'A Random sentence for describing a sample'
    click_button 'Create Project'
    expect(page).to have_content 'Project has been created.'

    project = Project.find_by(name: 'Sample Project')
    expect(page.current_url).to eq project_url(project)

    title = 'Sample Project - Projects - Ticketee'
    expect(page).to have_title title
  end

  scenario 'with invalid attributes' do
    visit '/'
    click_link 'New Project'
    click_button 'Create Project'
    expect(page).to have_content 'Project has not been created'
    expect(page).to have_content "Name can't be blank"
  end
end