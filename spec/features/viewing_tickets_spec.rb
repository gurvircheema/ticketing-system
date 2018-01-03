require 'rails_helper'

RSpec.feature 'Users can view tickets' do
  before do
    author = FactoryBot.create(:user)

    sublime = FactoryBot.create(:project, name: 'sublime text 3')
    assign_role!(author, :viewer, sublime)
    FactoryBot.create(
      :ticket, project: sublime, name: 'Sublime Ticket', author: author,
      description: 'Description that is atleast 10 digits long'
    )

    ie = FactoryBot.create(:project, name: 'IE')
    assign_role!(author, :viewer, ie)
    FactoryBot.create(
      :ticket, project: ie, name: 'Non standard compliance', description: 'it is a joke, really'
    )
    login_as(author)
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
