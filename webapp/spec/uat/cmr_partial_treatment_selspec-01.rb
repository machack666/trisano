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

require File.dirname(__FILE__) + '/spec_helper'

describe 'Adding partial treatments to a CMR' do
  
  #$dont_kill_browser = true
  
  it 'should allow a treatment to be added w/out a date specified' do
    @browser.open '/trisano/cmrs'
    click_nav_new_cmr(@browser).should be_true
    add_demographic_info(@browser, { :last_name => "Smith", :first_name => "Jersey" })
    add_treatment(@browser, {:treatment => "Leeches", :treatment_given => "label=Yes"})
    save_cmr(@browser).should be_true
    @browser.is_text_present('Treatment Date').should be_true
    @browser.is_text_present('Leeches').should be_true
  end

end
