require 'rails_helper'

RSpec.feature 'An Admin can archive users' do
  let(:admin_user) { FactoryBot.create(:user, :admin) }
  let(:user) { FactoryBot.create(:user, email: 'abs@example.com') }

  before do
    login_as(admin_user)
  end

  scenario 'succcessful' do
    visit admin_user_path(user)
    click_link 'Archive User'
    expect(page).to have_content 'User has been archived'
    expect(page).not_to have_content user.email
  end

  scenario 'but cannot archive themself' do
    visit admin_user_path(admin_user)
    click_link 'Archive User'
    expect(page).to have_content 'You cannot archive yourself!'
  end
end
