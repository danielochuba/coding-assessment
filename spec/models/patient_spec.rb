require 'rails_helper'

RSpec.describe Patient, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:age) }
    it { should validate_presence_of(:address) }
    it { should validate_numericality_of(:age).only_integer.is_greater_than(0) }
  end

  describe 'associations' do
    it { should have_many(:doctor_appointments).dependent(:destroy) }
  end

  describe 'instance methods' do
    let(:patient) { FactoryBot.create(:patient, first_name: 'Jane', last_name: 'Smith') }

    describe '#full_name' do
      it 'returns the full name of the patient' do
        expect(patient.full_name).to eq('Jane Smith')
      end
    end
  end

  describe 'scopes' do
    let!(:patient1) { FactoryBot.create(:patient, created_at: 1.day.ago) }
    let!(:patient2) { FactoryBot.create(:patient, created_at: 2.days.ago) }
    let!(:patient3) { FactoryBot.create(:patient, created_at: Time.current) }

    describe '.recent' do
      it 'returns patients ordered by most recently created' do
        expect(Patient.recent).to eq([patient3, patient1, patient2])
      end
    end
  end
end
