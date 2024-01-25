require 'rails_helper'

RSpec.describe Project, type: :model do
  subject { described_class.new(title: 'Test project') }

  describe 'Validation' do
    it 'is valid with title' do
      expect(subject).to be_valid
    end

    it 'is not valid without title' do
      subject.title = ''
      expect(subject).to_not be_valid
    end

    context 'when title is unique' do
      before { described_class.create!(title: 'Test project 1') }

      it 'is valid if the title is unique' do
        expect(subject).to be_valid
      end
    end

    context 'when title is not unique' do
      before { described_class.create!(title: 'Test project') }

      it 'is invalid if the title is not unique' do
        expect(subject).to_not be_valid
      end
    end
  end
end
