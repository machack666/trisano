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

require File.dirname(__FILE__) + '/../../spec_helper'

describe "/forms/_library_elements.haml" do

  before do
    @reference_element = Factory.build(:question_element)
    @reference_element.save_and_add_to_form
    @lib_element = Factory.create(:question_element)
    assigns[:reference_element] = @reference_element
    assigns[:library_elements] = [@lib_element]
  end


  it "renders from library" do
    render "forms/_library_elements.haml", {
      :locals => {
        :direction => :from_library,
        :type => "question_element" } }
  end

  it "renders to library" do
    render "forms/_library_elements.haml", {
      :locals => {
        :direction => :to_library,
        :type => "question_element" } }
  end

end
