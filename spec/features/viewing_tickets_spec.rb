require 'rails_helper'

RSpec.feature 'Users can view tickets' do
  before do
    sublime = FactoryBot.create(:project, name: 'sublime text 3')
    FactoryBot.create(
      :ticket, project: sublime, name: 'Sublime Ticket',
      description: 'Description that is atleast 10 digits long'
    )
    ie = FactoryBot.create(:project, name: 'IE')
    FactoryBot.create(
      :ticket, project: ie, name: 'Non standard compliance', description: 'it is a joke, really'
    )
    visit '/'
  end
  
  scenario 'for a given project' do
    click_link 'sublime text 3'
    expect(page).to have_content 'Sublime Ticket'
    expect(page).to_not have_content 'Non standard compliance'

    click_link 'Sublime Ticket'
    within('#ticket h2') do
      expect(page).to have_content 'Sublime Ticket'
    end
    expect(page).to have_content 'Description that is atleast 10 digits long'
  end
end