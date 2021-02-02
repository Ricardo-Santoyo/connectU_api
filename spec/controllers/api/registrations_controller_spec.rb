require 'rails_helper'

describe RegistrationsController, type: :request do

  let (:user) { build_user }
  let (:existing_user) { create_user }
  let (:signup_url) { '/api/signup' }

  context 'When creating a new user' do
    before do
      post signup_url, params: {
        user: {
          name: user.name,
          email: user.email,
          password: user.password
        }
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'returns a token' do
      expect(response.headers['Authorization']).to be_present
    end

    it 'returns the user name' do
      expect(json['data']).to have_attribute(:name).with_value(user.name)
    end

    it 'returns the user email' do
      expect(json['data']).to have_attribute(:email).with_value(user.email)
    end
  end

  context 'When an email already exists' do
    before do
      post signup_url, params: {
        user: {
          name: existing_user.name,
          email: existing_user.email,
          password: existing_user.password
        }
      }
    end

    it 'returns 400' do
      expect(response.status).to eq(400)
    end
  end

end