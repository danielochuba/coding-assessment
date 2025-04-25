require 'rails_helper'

RSpec.describe PatientsController, type: :controller do
  let(:receptionist) { FactoryBot.create(:user, role: :receptionist) }
  let(:doctor) { FactoryBot.create(:user, role: :doctor) }
  let(:valid_attributes) {
    { first_name: 'John', last_name: 'Doe', age: 30, address: '123 Main St' }
  }
  let(:invalid_attributes) {
    { first_name: '', last_name: '', age: nil, address: '' }
  }

  describe "GET #index" do
    context "when logged in" do
      before { sign_in receptionist }

      it "returns a success response" do
        get :index
        expect(response).to be_successful
      end
    end
  end

  describe "GET #show" do
    let(:patient) { Patient.create! valid_attributes }

    context "as a receptionist" do
      before { sign_in receptionist }

      it "returns a success response" do
        get :show, params: { id: patient.to_param }
        expect(response).to be_successful
      end
    end

    context "as a doctor" do
      before { sign_in doctor }

      it "returns a success response" do
        get :show, params: { id: patient.to_param }
        expect(response).to be_successful
      end
    end
  end

  describe "GET #new" do
    context "as a receptionist" do
      before { sign_in receptionist }

      it "returns a success response" do
        get :new
        expect(response).to be_successful
      end
    end

    context "as a doctor" do
      before { sign_in doctor }

      it "redirects due to lack of permission" do
        get :new
        expect(response).to have_http_status(:redirect)
      end
    end
  end

  describe "GET #edit" do
    let(:patient) { Patient.create! valid_attributes }

    context "as a receptionist" do
      before { sign_in receptionist }

      it "returns a success response" do
        get :edit, params: { id: patient.to_param }
        expect(response).to be_successful
      end
    end

    context "as a doctor" do
      before { sign_in doctor }

      it "redirects due to lack of permission" do
        get :edit, params: { id: patient.to_param }
        expect(response).to have_http_status(:redirect)
      end
    end
  end

  describe "POST #create" do
    context "as a receptionist" do
      before { sign_in receptionist }

      it "creates a new Patient with valid params" do
        expect {
          post :create, params: { patient: valid_attributes }
        }.to change(Patient, :count).by(1)
      end

      it "doesn't create with invalid params" do
        expect {
          post :create, params: { patient: invalid_attributes }
        }.not_to change(Patient, :count)
      end
    end

    context "as a doctor" do
      before { sign_in doctor }

      it "doesn't create a patient due to permissions" do
        expect {
          post :create, params: { patient: valid_attributes }
        }.not_to change(Patient, :count)
      end
    end
  end

  describe "PUT #update" do
    let(:patient) { Patient.create! valid_attributes }
    let(:new_attributes) {
      { first_name: 'Jane', last_name: 'Smith', age: 25, address: '456 Oak St' }
    }

    context "as a receptionist" do
      before { sign_in receptionist }

      context "with valid params" do
        it "updates the requested patient" do
          put :update, params: { id: patient.to_param, patient: new_attributes }
          patient.reload
          expect(patient.first_name).to eq('Jane')
          expect(patient.last_name).to eq('Smith')
          expect(patient.age).to eq(25)
          expect(patient.address).to eq('456 Oak St')
        end

        it "redirects to the patient" do
          put :update, params: { id: patient.to_param, patient: valid_attributes }
          expect(response).to redirect_to(patient)
        end
      end

      context "with invalid params" do
        it "returns a success response (i.e. to display the 'edit' template)" do
          put :update, params: { id: patient.to_param, patient: invalid_attributes }
          expect(response).to be_successful
        end
      end
    end

    context "as a doctor" do
      before { sign_in doctor }

      it "does not update the patient and redirects" do
        put :update, params: { id: patient.to_param, patient: new_attributes }
        patient.reload
        expect(patient.first_name).not_to eq('Jane')
        expect(response).to have_http_status(:redirect)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:patient) { Patient.create! valid_attributes }

    context "as a receptionist" do
      before { sign_in receptionist }

      it "destroys the requested patient" do
        expect {
          delete :destroy, params: { id: patient.to_param }
        }.to change(Patient, :count).by(-1)
      end
    end

    context "as a doctor" do
      before { sign_in doctor }

      it "doesn't destroy due to permissions" do
        expect {
          delete :destroy, params: { id: patient.to_param }
        }.not_to change(Patient, :count)
      end
    end
  end
end
