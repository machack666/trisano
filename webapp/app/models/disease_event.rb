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

class DiseaseEvent < ActiveRecord::Base
  belongs_to :hospitalized, :class_name => 'ExternalCode'
  belongs_to :died, :class_name => 'ExternalCode'

  belongs_to :event
  belongs_to :disease

  validates_uniqueness_of :event_id
  validates_date :disease_onset_date, :allow_blank => true
  validates_date :date_diagnosed, :allow_blank => true,
                                  :on_or_before => lambda { Date.today },
                                  :on_or_after => :disease_onset_date

  def xml_fields
    [[:hospitalized_id,   {:rel => :yesno }],
     [:disease_id,        {:rel => :disease}],
     :disease_onset_date,
     :date_diagnosed,
     [:died_id,           {:rel => :yesno}]]
  end
end
