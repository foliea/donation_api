require 'rails_helper'

RSpec.describe User, type: :model do
  subject { User.new(api_token: SecureRandom.hex(20)) }

  it "is valid with a unique api_token" do
    expect(subject).to be_valid
  end

  it "is invalid without an api_token" do
    subject.api_token = nil

    expect(subject).not_to be_valid

    expect(subject.errors[:api_token]).to include("can't be blank")
  end

  it "ensures api_token uniqueness" do
    subject.save!

    duplicate_user = User.create(api_token: subject.api_token)

    expect(duplicate_user).not_to be_valid

    expect(duplicate_user.errors[:api_token]).to include("has already been taken")
  end
end
