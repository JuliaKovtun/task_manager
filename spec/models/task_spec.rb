require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:project) { Project.create(title: 'Test project') }
  subject { described_class.new(title: 'Test task', project_id: project.id, status: :new) }

  describe 'Validation' do
    it 'is valid with title' do
      expect(subject).to be_valid
    end

    it 'is not valid without title' do
      subject.title = ''
      expect(subject).to_not be_valid
    end

    context 'when title is unique' do
      before { described_class.create!(title: 'Test task 1', project_id: project.id) }

      it 'is valid if the title is unique' do
        expect(subject).to be_valid
      end
    end

    context 'when title is not unique' do
      before { described_class.create!(title: 'Test task', project_id: project.id) }

      it 'is invalid if the title is not unique' do
        expect(subject).to_not be_valid
      end
    end
  end
end
