require 'rails_helper'

RSpec.describe TicketsController, type: :controller do
  let(:project) { FactoryBot.create :project }
  let(:user) { FactoryBot.create :user}

  before :each do
    assign_role!(user, :editor, project)
    sign_in user
  end

  it 'can create tickets, but not tag them' do
    post :create,
         ticket: {
           name: 'New ticket',
           description: 'longer than 10',
           tag_names: 'one two'
         },
         project_id: project.id
    expect(Ticket.last.tags).to be_empty
  end
end
