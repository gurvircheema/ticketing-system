require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { FactoryBot.create :user }
  let(:project) { FactoryBot.create :project }
  let(:state) { FactoryBot.create :state, name: 'Hacked' }
  let(:ticket) do
    project.tickets.create(
      name: 'State transitions', description: "Can't be hacked",
      author: user
    )
  end

  context 'a user without permission to set state' do
    before :each do
      assign_role!(user, :editor, project)
      sign_in user
    end

    it 'cannot transition a state by passing through state_id' do
      post :create,
           comment: { text: 'Did i hack it?', state_id: state.id },
           ticket_id: ticket.id
      ticket.reload
      expect(ticket.state).to be_nil
    end
  end

  context 'a user without permission to tag a ticket' do
    before do
      assign_role!(user, :editor, project)
      sign_in user
    end

    it 'cannot tag a ticket when creating a comment' do
      post :create,
           comment: { text: 'tag', tag_names: 'one two' },
           ticket_id: ticket.id
      ticket.reload
      expect(ticket.tags).to be_empty
    end
  end
end
