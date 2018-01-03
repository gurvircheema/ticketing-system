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
end
