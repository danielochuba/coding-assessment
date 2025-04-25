require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability, type: :model do
  describe 'Doctor permissions' do
    let(:doctor) { FactoryBot.create(:user, role: :doctor) }
    let(:ability) { Ability.new(doctor) }
    let(:patient) { FactoryBot.create(:patient) }
    let(:doctor_appointment) { FactoryBot.create(:doctor_appointment, user: doctor, patient: patient) }
    let(:other_doctor) { FactoryBot.create(:user, role: :doctor) }
    let(:other_doctor_appointment) { FactoryBot.create(:doctor_appointment, user: other_doctor, patient: patient) }

    it 'can read patients' do
      expect(ability).to be_able_to(:read, Patient)
    end

    it 'cannot create patients' do
      expect(ability).not_to be_able_to(:create, Patient)
    end

    it 'cannot update patients' do
      expect(ability).not_to be_able_to(:update, Patient)
    end

    it 'cannot destroy patients' do
      expect(ability).not_to be_able_to(:destroy, Patient)
    end

    it 'can manage own appointments' do
      expect(ability).to be_able_to(:manage, doctor_appointment)
    end

    it 'cannot manage other doctors appointments' do
      expect(ability).not_to be_able_to(:manage, other_doctor_appointment)
    end
  end

  describe 'Receptionist permissions' do
    let(:receptionist) { FactoryBot.create(:user, role: :receptionist) }
    let(:ability) { Ability.new(receptionist) }
    let(:patient) { FactoryBot.create(:patient) }
    let(:doctor) { FactoryBot.create(:user, role: :doctor) }
    let(:doctor_appointment) { FactoryBot.create(:doctor_appointment, user: doctor, patient: patient) }

    it 'can manage patients' do
      expect(ability).to be_able_to(:manage, Patient)
    end

    it 'can create new patients' do
      expect(ability).to be_able_to(:create, Patient.new)
    end

    it 'can see all appointments' do
      expect(ability).to be_able_to(:read, doctor_appointment)
    end

    it 'can create appointments' do
      expect(ability).to be_able_to(:create, DoctorAppointment)
    end

    it 'can update appointments' do
      expect(ability).to be_able_to(:update, doctor_appointment)
    end

    it 'can delete appointments' do
      expect(ability).to be_able_to(:destroy, doctor_appointment)
    end
  end
end
