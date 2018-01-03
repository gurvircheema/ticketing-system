require 'rails_helper'

RSpec.feature 'Users can edit existing projects' do
  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project, name: 'Sublime Text 3') }

  before do
    login_as(user)
    assign_role!(user, :viewer, project)
    visit "/"
    click_link "Sublime Text 3"
    click_link "Edit Project"
  end

  scenario 'with valid attributes' do
    fill_in 'Name', with: 'Code'
    click_button 'Update Project'
    expect(page).to have_content 'Project has been updated'
    expect(page).to have_content 'Code'
  end

  scenario 'when providing invalid attributes' do
    fill_in 'Name', with: ''
    click_button 'Update Project'
    expect(page).to have_content 'Project has not been updated'
  end
end
