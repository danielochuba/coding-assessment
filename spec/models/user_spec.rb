require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:role) }
  end

  describe 'associations' do
    it { should have_many(:doctor_appointments) }
  end

  describe 'enum' do
    it 'defines role enum with correct values' do
      should define_enum_for(:role).with_values(doctor: 0, receptionist: 1)
    end
  end

  describe 'instance methods' do
    let(:doctor) { FactoryBot.create(:user, role: :doctor) }
    let(:receptionist) { FactoryBot.create(:user, role: :receptionist) }

    describe '#doctor?' do
      it 'returns true if user is a doctor' do
        expect(doctor.doctor?).to be true
      end

      it 'returns false if user is not a doctor' do
        expect(receptionist.doctor?).to be false
      end
    end

    describe '#receptionist?' do
      it 'returns true if user is a receptionist' do
        expect(receptionist.receptionist?).to be true
      end

      it 'returns false if user is not a receptionist' do
        expect(doctor.receptionist?).to be false
      end
    end

    describe '#full_name' do
      let(:user) { FactoryBot.create(:user, first_name: 'John', last_name: 'Doe') }

      it 'returns first name and last name combined' do
        expect(user.full_name).to eq('John Doe')
      end
    end
  end
end
