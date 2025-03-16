require 'rails_helper'

RSpec.describe Project, type: :model do
  subject { Project.new(name: "Charity month") }

  it "is valid with a name" do
    expect(subject).to be_valid
  end

  it "is invalid without a name" do
    subject.name = nil

    expect(subject).not_to be_valid

    expect(subject.errors[:name]).to include("can't be blank")
  end
end
