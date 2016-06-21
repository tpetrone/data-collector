require 'rails_helper'

RSpec.describe SensorValue, type: :model do

  let(:sensor_value_default) { create(:sensor_value) }

  it "has a valid factory" do
    expect(sensor_value_default).to be_valid
  end

  it "has a date of occurence" do
    expect(sensor_value_default.date).not_to be_nil
    expect(sensor_value_default.date).not_to eq('')
    expect(FactoryGirl.build(:sensor_value, :date => "")).not_to be_valid
    expect(FactoryGirl.build(:sensor_value, :date => nil)).not_to be_valid
  end

  it "belongs to a resource in the platform" do
    expect(sensor_value_default.platform_resource).to_not be_nil
    expect(sensor_value_default.platform_resource.uuid).to_not be_nil

    expect(FactoryGirl.build(:sensor_value, :platform_resource_id => "")).not_to be_valid
    expect(FactoryGirl.build(:sensor_value, :platform_resource_id => nil)).not_to be_valid
    expect(FactoryGirl.build(:sensor_value, :platform_resource => nil)).not_to be_valid
  end

  it "has a capability type" do
    expect(sensor_value_default.capability).to_not be_nil

    expect(FactoryGirl.build(:sensor_value, :capability_id => "")).not_to be_valid
    expect(FactoryGirl.build(:sensor_value, :capability_id => nil)).not_to be_valid
    expect(FactoryGirl.build(:sensor_value, :capability => nil)).not_to be_valid
  end

  it "has a valid resource id" do
  	uuid = sensor_value_default.platform_resource.uuid
    expect(uuid).not_to eq('')

    uuid_pattern = /^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$/
    expect(uuid_pattern.match(uuid)).not_to be_nil
  end

  it "has a value" do
    expect(sensor_value_default.value).not_to be_nil
    expect(sensor_value_default.value).not_to eq('')

    expect(FactoryGirl.build(:sensor_value, :value => "")).not_to be_valid
    expect(FactoryGirl.build(:sensor_value, :value => nil)).not_to be_valid
  end

end
