require 'rails_helper'

RSpec.feature 'Admins can manage a users roles' do
  let(:admin) { FactoryBot.create(:user, :admin) }
  let(:user) { FactoryBot.create(:user) }

  let!(:ie) { FactoryBot.create :project, name: 'IE' }
  let!(:st3) { FactoryBot.create :project, name: 'Sublime Text 3' }

  before do
    login_as(admin)
  end

  scenario 'when assigning roles to an existing user' do
    visit admin_user_path(user)
    click_link 'Edit User'
    select 'Viewer', from: 'IE'
    select 'Manager', from: 'Sublime Text 3'
    click_button 'Update User'
    expect(page).to have_content 'User has been updated'

    click_link user.email
    expect(page).to have_content 'IE: Viewer'
    expect(page).to have_content 'Sublime Text 3: Manager'
  end

  scenario 'when assigning roles to a new user' do
    visit new_admin_user_path

    fill_in 'Email', with: 'johndoe@gmail.com'
    fill_in 'Password', with: 'password'
    select 'Editor', from: 'IE'
    click_button 'Create User'

    click_link 'johndoe@gmail.com'
    expect(page).to have_content 'IE: Editor'
    expect(page).not_to have_content 'Sublime Text 3'
  end
end
