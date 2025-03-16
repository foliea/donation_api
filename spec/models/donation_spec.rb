require 'rails_helper'

RSpec.describe Donation, type: :model do
  let(:user) { User.create!(api_token: SecureRandom.hex(20)) }
  let(:project_id) { 1 }

  subject { Donation.new(amount: 100, currency: 'USD', project_id: project_id, user: user) }

  describe 'valid donation' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end
  end

  describe 'invalid donation' do
    it 'is invalid without an amount' do
      subject.amount = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:amount]).to include("can't be blank")
    end

    it 'is invalid with a non-numeric amount' do
      subject.amount = 'abc'
      expect(subject).not_to be_valid
      expect(subject.errors[:amount]).to include("is not a number")
    end

    it 'is invalid without a currency' do
      subject.currency = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:currency]).to include("can't be blank")
    end

    it 'is invalid without a project_id' do
      subject.project_id = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:project_id]).to include("can't be blank")
    end

    it 'is invalid if the amount is less than or equal to zero' do
      subject.amount = 0
      expect(subject).not_to be_valid
      expect(subject.errors[:amount]).to include("must be greater than 0")

      subject.amount = -5
      expect(subject).not_to be_valid
      expect(subject.errors[:amount]).to include("must be greater than 0")
    end
  end
end
