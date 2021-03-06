# Copyright (C) 2007, 2008, 2009, 2010, 2011 The Collaborative Software Foundation
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

require 'spec_helper'

describe ParticipationsTreatment, "in the Perinatal Hep B plugin" do

  describe "on a contact event with the disease Hep" do

    before(:each) do
      @event = Factory.create(:contact_with_disease)
      @treatment = Factory.create(:treatment)
      @event.interested_party.treatments.create!(:treatment_id => @treatment.id)
    end

    describe "when validating treatment date" do

      before(:each) do
        @dsv = Factory.create(:disease_specific_validation,
          :validation_key => "treatment_date_required",
          :disease => @event.disease.disease
        )

        @treatment = Factory.create(:treatment)
        @event.interested_party.treatments[0].treatment = @treatment
      end

      it "should allow a treatment provided it has a treatment date" do
        @event.interested_party.treatments[0].treatment_date = Date.yesterday
        @event.save
        @event.interested_party.treatments[0].errors.on(:treatment_date).should be_nil
      end

      it "should not allow for a blank treatment date" do
        @event.interested_party.treatments[0].treatment_date = nil
        @event.save
        @event.interested_party.treatments[0].errors.on(:treatment_date).should == "can't be blank"
      end

    end
  end
end
