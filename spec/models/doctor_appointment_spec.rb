require 'rails_helper'

RSpec.describe DoctorAppointment, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:date) }
    it { should validate_presence_of(:illness) }
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:patient_id) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:patient) }
  end

  describe 'scopes' do
    let(:user) { FactoryBot.create(:user, role: :doctor) }
    let(:patient) { FactoryBot.create(:patient) }

    let!(:past_appointment) { FactoryBot.create(:doctor_appointment, user: user, patient: patient, date: 1.day.ago) }
    let!(:future_appointment) { FactoryBot.create(:doctor_appointment, user: user, patient: patient, date: 1.day.from_now) }
    let!(:today_appointment) { FactoryBot.create(:doctor_appointment, user: user, patient: patient, date: Date.current) }

    describe '.upcoming' do
      it 'returns appointments in the future' do
        expect(DoctorAppointment.upcoming).to include(future_appointment)
        expect(DoctorAppointment.upcoming).not_to include(past_appointment)
      end
    end

    describe '.past' do
      it 'returns appointments from the past' do
        expect(DoctorAppointment.past).to include(past_appointment)
        expect(DoctorAppointment.past).not_to include(future_appointment)
      end
    end

    describe '.for_doctor' do
      let(:other_doctor) { FactoryBot.create(:user, role: :doctor) }
      let!(:other_appointment) { FactoryBot.create(:doctor_appointment, user: other_doctor, patient: patient) }

      it 'returns appointments for a specific doctor' do
        expect(DoctorAppointment.for_doctor(user.id)).to include(past_appointment, future_appointment, today_appointment)
        expect(DoctorAppointment.for_doctor(user.id)).not_to include(other_appointment)
      end
    end

    describe '.for_patient' do
      let(:other_patient) { FactoryBot.create(:patient) }
      let!(:other_patient_appointment) { FactoryBot.create(:doctor_appointment, user: user, patient: other_patient) }

      it 'returns appointments for a specific patient' do
        expect(DoctorAppointment.for_patient(patient.id)).to include(past_appointment, future_appointment, today_appointment)
        expect(DoctorAppointment.for_patient(patient.id)).not_to include(other_patient_appointment)
      end
    end
  end
end
