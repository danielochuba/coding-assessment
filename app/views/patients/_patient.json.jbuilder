json.extract! patient, :id, :name, :date_of_birth, :gender, :phone, :user_id, :created_at, :updated_at
json.url patient_url(patient, format: :json)
