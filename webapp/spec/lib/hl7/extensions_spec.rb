# Copyright (C) 2007, 2008, 2009, 2010 The Collaborative Software Foundation
#
# This file is part of TriSano.
#
# TriSano is free software: you can redistribute it and/or modify it under the
# terms of the GNU Affero General Public License as published by the
# Free Software Foundation, either version 3 of the License,
# or (at your option) any later version.
#
# TriSano is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with TriSano. If not, see http://www.gnu.org/licenses/agpl-3.0.txt.

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

include HL7

describe Message do
  before :each do
    @hl7 = HL7::Message.parse(hl7_messages[:arup_1])
  end

  it 'should respond to :message_header' do
    @hl7.should respond_to(:message_header)
  end

  it 'should respond to :patient_id' do
    @hl7.should respond_to(:patient_id)
  end

  it 'should respond to :observation_requests' do
    @hl7.should respond_to(:observation_requests)
  end

  it 'should respond to :enhanced_ack_mode?' do
    @hl7.should respond_to(:enhanced_ack_mode?)
  end

  it 'should return a message_header' do
    @hl7.message_header.class.should == StagedMessages::MshWrapper
  end

  it 'should return a patient ID' do
    @hl7.patient_id.class.should == StagedMessages::PidWrapper
  end

  it 'should return an array of observation requests' do
    @hl7.observation_requests.class.should == Array
  end

  it 'should parse the Realm minimal sample message' do
    # Basic sanity check: Pass in an actual 2.5.1 message.
    HL7::Message.parse HL7MESSAGES[:realm_minimal_message]
  end

  describe 'original and enhanced ack modes' do
    it 'should recognize the Realm minimal message as enhanced mode' do
      HL7::Message.parse(HL7MESSAGES[:realm_minimal_message]).should be_enhanced_ack_mode
    end

    it 'should recognize the NIST-1 sample message as original mode' do
      HL7::Message.parse(HL7MESSAGES[:nist_sample_1]).should_not be_enhanced_ack_mode
    end
  end

  describe 'message header' do
    it 'should return the sending facility (without noise)' do
      @hl7.message_header.sending_facility.should == 'ARUP LABORATORIES'
    end
  end

  describe 'patient identifier' do
    # PID|1||17744418^^^^MR||LIN^GENYAO^^^^^L||19840810|M||U^Unknown^HL70005|215 UNIVERSITY VLG^^SALT LAKE CITY^UT^84108^^M||^^PH^^^801^5854967|||||||||U^Unknown^HL70189\rORC||||||||||||^ROSENKOETTER^YUKI^K|||||||||University Hospital UT|50 North Medical Drive^^Salt Lake City^UT^84132^USA^B||^^^^^USA^B

    it 'should return the patient name (formatted)' do
      @hl7.patient_id.patient_name.should == 'Lin, Genyao'
    end

    it 'should return the patient birth date' do
      @hl7.patient_id.birth_date.should == Date.parse("19840810")
    end

    it 'should return the patient sex ID' do
      @hl7.patient_id.trisano_sex_id.should == external_codes(:gender_male).id
    end

    it 'should return the patient race ID' do
      @hl7.patient_id.trisano_race_id.should == external_codes(:race_unknown).id
    end

    it "should have a non-empty address" do
      @hl7.patient_id.address_empty?.should == false
    end

    it "should have an empty address if there is one" do
      hl7 = HL7::Message.parse(hl7_messages[:arup_simple_pid])
      hl7.patient_id.address_empty?.should == true
    end

    it 'should return the street number' do
      @hl7.patient_id.address_street_no.should == '215'
    end

    it 'should return the unit no' do
      @hl7.patient_id.address_unit_no.should be_blank
    end

    it 'should return the street name' do
      @hl7.patient_id.address_street.should == "University Vlg"
    end

    it 'should return the city' do
      @hl7.patient_id.address_city.should == "Salt Lake City"
    end

    it 'should return the state ID' do
      @hl7.patient_id.address_trisano_state_id.should == external_codes(:state_utah).id
    end

    it 'should return the zip code' do
      @hl7.patient_id.address_zip.should == "84108"
    end

    it "should have a non-empty telephone" do
      @hl7.patient_id.telephone_empty?.should == false
    end

    it "should have an empty telephone if there is one" do
      hl7 = HL7::Message.parse(hl7_messages[:arup_simple_pid])
      hl7.patient_id.telephone_empty?.should == true
    end

    it "should return the phone number components" do
      a, n, e = @hl7.patient_id.telephone_home
      a.should == "801"
      n.should == "5854967"
      e.should be_blank
    end

    it "should return the phone number components when encoded as a single string" do
      hl7 = HL7::Message.parse(hl7_messages[:ihc_1])
      a, n, e = hl7.patient_id.telephone_home
      a.should == "801"
      n.should == "7317292"
      e.should be_blank
    end

    it 'should properly parse a PHIN White race code in an HL7 2.5.1 message' do
      hl7 = HL7::Message.parse HL7MESSAGES[:realm_minimal_message]
      hl7.patient_id.trisano_race_id.should == external_codes(:race_white).id
    end

    it 'should properly parse a PHIN Asian race code in an HL7 2.5.1 message' do
      hl7 = HL7::Message.parse HL7MESSAGES[:realm_campy_jejuni_asian]
      hl7.patient_id.trisano_race_id.should == external_codes(:race_asian).id
    end

    it 'should properly parse a PHIN American Indian or Alaskan Native race code in an HL7 2.5.1 message' do
      hl7 = HL7::Message.parse HL7MESSAGES[:realm_campy_jejuni_ai_or_an]
      hl7.patient_id.trisano_race_id.should include(external_codes(:race_indian).id)
      hl7.patient_id.trisano_race_id.should include(external_codes(:race_alaskan).id)
      hl7.patient_id.trisano_race_id.size.should == 2
    end

    it 'should properly parse a PHIN Black or African American race code in an HL7 2.5.1 message' do
      hl7 = HL7::Message.parse HL7MESSAGES[:realm_campy_jejuni_black]
      hl7.patient_id.trisano_race_id.should == external_codes(:race_black).id
    end

    it 'should properly parse a PHIN Native Hawaiian or Other Pacific Islander race code in an HL7 2.5.1 message' do
      hl7 = HL7::Message.parse HL7MESSAGES[:realm_campy_jejuni_hawaiian]
      hl7.patient_id.trisano_race_id.should == external_codes(:race_hawaiian).id
    end

    it 'should properly parse a PHIN Unknown race code in an HL7 2.5.1 message' do
      hl7 = HL7::Message.parse HL7MESSAGES[:realm_campy_jejuni_unknown]
      hl7.patient_id.trisano_race_id.should == external_codes(:race_unknown).id
    end

    it 'should handle parsing a bad race code in an HL7 2.5.1 message' do
      hl7 = HL7::Message.parse HL7MESSAGES[:realm_campy_jejuni_bad_race_condition]
      hl7.patient_id.trisano_race_id.should == external_codes(:race_unknown).id
    end
  end

  describe 'observation request' do
    it 'should return the test performed (without noise)' do
      @hl7.observation_requests.first.test_performed.should == 'Hepatitis Be Antigen'
    end

    it 'should return the collection date' do
      @hl7.observation_requests.first.collection_date.should == '2009-03-19'
    end

    it 'should return the specimen source' do
      @hl7.observation_requests.first.specimen_source.should == 'BLOOD'
    end

    it 'should return a list of test_results' do
      @hl7.observation_requests.first.tests.should_not be_nil
    end

    describe 'specimen segment' do
      before :all do
        # This is an OBR segment that should have an SPM segment.
        @arup_3 = HL7::Message.parse(hl7_messages[:arup_3]).observation_requests.first
      end

      it 'should be an SpmWrapper object' do
        @arup_3.specimen.should be_a(StagedMessages::SpmWrapper)
      end

      it 'should have an :spm_segment method returning an SPM object' do
        @arup_3.specimen.spm_segment.should be_an(HL7::Message::Segment::SPM)
      end

      it 'should return \'Whole Blood\' as the specimen source' do
        @arup_3.specimen_source.should == 'Whole Blood'
      end
    end

    describe 'tests' do
      before :each do
        @tests = @hl7.observation_requests.first.tests
      end

      it 'should be a list' do
        @tests.should respond_to(:each)
      end

      it 'should not be an empty list' do
        @tests.should_not be_empty
      end

      it 'should return observation_date' do
        @tests[0].observation_date.should == '2009-03-21'
      end

      it 'should return result' do
        @tests[0].result.should == 'Positive'
      end

      it 'should return a reference range' do
        @tests[0].reference_range.should == 'Negative'
      end

      it 'should return the test type (without the noise)' do
        @tests[0].test_type.should == 'Hepatitis Be Antigen'
      end
    end

    describe 'the ObxWrapper' do
      before :all do
        @realm_min_test =
          HL7::Message.parse(HL7MESSAGES[:realm_minimal_message]).observation_requests.first.all_tests.first
        @realm_cj_test =
          HL7::Message.parse(HL7MESSAGES[:realm_campylobacter_jejuni]).observation_requests.first.all_tests.first
        @realm_ar_test =
          HL7::Message.parse(HL7MESSAGES[:realm_animal_rabies]).observation_requests.first.all_tests.first
      end

      it 'should take :loinc_scale from CWE.2 if present' do
        @realm_cj_test.loinc_scale.should == 'Nom'
      end

      it 'should take :loinc_scale from OBX-2 if not present in CWE.2' do
        @realm_min_test.loinc_scale.should == 'Qn'
      end

      it 'should return a nil :loinc_scale if not present in CWE.2 or OBX-2' do
        @realm_ar_test.loinc_scale.should be_nil
      end

      it 'should take :loinc_common_test_type from CWE.2 if present' do
        @realm_cj_test.loinc_common_test_type.should == 'Culture'
      end

      it 'should return a nil :loinc_common_test_type if not present in CWE.2' do
        @realm_ar_test.loinc_common_test_type.should be_nil
      end

      it 'should parse a CWE result properly' do
        @realm_cj_test.result.should == 'Campylobacter jejuni'
        @realm_ar_test.result.should == 'Detected'
      end

      it 'should parse a Default result properly' do
        @realm_min_test.result.should == '50'
      end
    end
  end

  describe 'batch processing' do
    it 'should have a class method HL7::Message.parse_batch' do
      HL7::Message.should respond_to(:parse_batch)
    end

    it 'should raise an exception when parsing an empty batch' do
      # :empty_batch message contains a valid batch envelope with no
      # contents
      lambda do
        HL7::Message.parse_batch HL7MESSAGES[:empty_batch]
      end.should raise_exception(HL7::ParseError, 'empty batch message')
    end

    it 'should raise an exception when parsing a single message as a batch' do
      lambda do
        HL7::Message.parse_batch HL7MESSAGES[:realm_minimal_message]
      end.should raise_exception(HL7::ParseError, 'badly formed batch message')
    end

    it 'should yield multiple messages from a valid batch' do
      count = 0
      HL7::Message.parse_batch(HL7MESSAGES[:realm_batch]) do |m|
        count += 1
      end
      count.should == 2
    end
  end
end

describe 'String extension' do
  before :all do
    @batch_message = HL7MESSAGES[:realm_batch]
    @plain_message = HL7MESSAGES[:realm_minimal_message]
  end

  it 'should respond_to :hl7_batch?' do
    @batch_message.should respond_to(:hl7_batch?)
    @plain_message.should respond_to(:hl7_batch?)
  end

  it 'should return true when passed a batch message' do
    @batch_message.should be_an_hl7_batch
  end

  it 'should return false when passed a plain message' do
    @plain_message.should_not be_an_hl7_batch
  end
end
