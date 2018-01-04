require 'spec_helper'

describe AttachmentPolicy do
  context 'permissions' do
    subject { AttachmentPolicy.new(user, attachment) }

    let(:user) { FactoryBot.create :user }
    let(:project) { FactoryBot.create :project }
    let(:ticket) { FactoryBot.create :ticket, project: project, author: user }
    let(:attachment) { FactoryBot.create :attachment, ticket: ticket }

    context 'for anonymous users' do
      let(:user) { nil }
      it { should_not permit_action :show }
    end

    context "for viewers of the project" do
      before { assign_role!(user, :viewer, project) }
      it { should permit_action :show }
    end

    context "for editors of the project" do
      before { assign_role!(user, :editor, project) }
      it { should permit_action :show }
    end

    context "for managers of the project" do
      before { assign_role!(user, :manager, project) }
      it { should permit_action :show }
    end

    context "for managers of other projects" do
      before do
        assign_role!(user, :manager, FactoryBot.create(:project))
      end
      it { should_not permit_action :show }
    end

    context "for administrators" do
      let(:user) { FactoryBot.create :user, :admin }
      it { should permit_action :show }
    end
  end
end
