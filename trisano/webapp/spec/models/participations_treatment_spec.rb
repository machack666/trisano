require File.dirname(__FILE__) + '/../spec_helper'

describe ParticipationsTreatment do
  before(:each) do
    @pt = ParticipationsTreatment.new
  end

  it "should be valid with nothing populated" do
    @pt.should be_valid
  end
  
  it "should be valid with any treatment text and treatment received y/n" do
    @pt.treatment = "Foot massage"
    @pt.treatment_given_yn_id = 1401
    @pt.should be_valid
  end

  it "should validate the treatment date" do
    @pt.treatment_date = 'not a date'
    @pt.should_not be_valid
  end
end
