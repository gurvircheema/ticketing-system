require 'rails_helper'

describe ProjectPolicy do

  let(:user) { User.new }

  subject { ProjectPolicy }

  permissions :show? do
    let(:user) { FactoryBot.create(:user, email: 'bs@gmail.com') }
    let(:project) { FactoryBot.create(:project) }
    it 'blocks anonymous users' do
      expect(subject).not_to permit(nil, project)
    end

    it 'allows viewers of the project' do
      assign_role!(user, :viewer, project)
      expect(subject).to permit(user, project)
    end

    it 'allows editors of the project' do
      assign_role!(user, :editor, project)
      expect(subject).to permit(user, project)
    end

    it 'allows managers of the project' do
      assign_role!(user, :manager, project)
      expect(subject).to permit(user, project)
    end

    it 'allows administrators' do
      admin = FactoryBot.create(:user, :admin)
      expect(subject).to permit(admin, project)
    end

    it 'doesnt allow users assigned to other projects' do
      other_project = FactoryBot.create(:project)
      assign_role!(user, :manager, other_project)
      expect(subject).not_to permit(user, project)
    end
  end
end
