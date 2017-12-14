require 'rails_helper'

RSpec.feature 'Users can create new projects' do
  scenario 'with valid attributes' do
    visit '/'
    click_link 'New Project' do
      fill_in 'Name', with: 'Sample Project'
      fill_in 'Description', with: 'A Random sentence for describing a sample'
      click_button 'Create Project'
      expect(page).to have_content 'Project has been created.'
    end
  end
end