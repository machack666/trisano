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

class AssociateStagedMessagesWithLabResults < ActiveRecord::Migration

  def self.up
    add_column :lab_results, :staged_message_id, :integer
    remove_column :staged_messages, :event_id
    add_index :lab_results, :staged_message_id, :name => "lab_results_staged_message"
  end

  def self.down
    remove_index :lab_results, :name => "lab_results_staged_message"
    remove_column :lab_results, :staged_message_id
    add_column :staged_messages, :event_id, :integer
  end
end
