require 'rails_helper'

describe Detail, :type => :model do

  pending "add some examples to (or delete) #{__FILE__}"
  pending "can be described as a JSON object"  # Test in controller later

  let(:detail) { create(:detail) }

  it "is generated by a component" do
    # It should already be registered by the Resource Adaptor, hence the "not nil"
    expect(detail.component_uuid).should_not be_nil
    expect(detail.component_uuid).to be >= 0
    FactoryGirl.build(:detail, :component_uuid => "").should_not be_valid
  end

  it "has a capability" do
    expect(detail.capability).should_not be_nil
    expect(detail.capability).should_not eq('')
    FactoryGirl.build(:detail, :capability => "").should_not be_valid
  end

  it "has a type" do
    expect(detail.type).should_not be_nil
    expect(detail.type).should_not eq('')
    FactoryGirl.build(:detail, :type => "").should_not be_valid
  end

  it "has a unit of measurement" do
    expect(detail.unit).should_not be_nil
    expect(detail.unit).should_not eq('')
    FactoryGirl.build(:detail, :unit => "").should_not be_valid
  end

  it "has a value" do
    expect(detail.value).should_not be_nil
    expect(detail.value).should_not eq('')
    FactoryGirl.build(:detail, :value => "").should_not be_valid
  end

  it "belongs to an event" do
    expect(detail).should belongs_to detail.event
  end

end
