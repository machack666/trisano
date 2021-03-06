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

class PeriHepB_metadata
  def initialize(conn, get_query_results)
    @conn = conn
    @get_query_results = get_query_results
    # Add core_tables, core_columns, and core_relationships entries if necessary
    queries = [
%{
  DELETE FROM trisano.core_columns WHERE
    target_table = 'trisano.dw_morbidity_events_view' AND
    target_column IN (
        'expected_delivery_facility',
        'expected_delivery_facility_type',
        'expected_delivery_facility_phone',
        'actual_delivery_date',
        'actual_delivery_facility_type',
        'actual_delivery_facility_phone',
        'actual_delivery_facility',
        'hcp_first_name',
        'hcp_last_name',
        'hcp_middle_name',
        'hcp_phones'
    );
},
%{
  INSERT INTO trisano.core_columns (target_column, target_table, column_name, column_description, make_category_column) VALUES
    ('expected_delivery_facility',       'trisano.dw_morbidity_events_view', 'expected_delivery_facility',       'ME Expctd Del Fac',         true),
    ('expected_delivery_facility_type',  'trisano.dw_morbidity_events_view', 'expected_delivery_facility_type',  'ME Expctd Del Fac Typ',     true),
    ('expected_delivery_facility_phone', 'trisano.dw_morbidity_events_view', 'expected_delivery_facility_phone', 'ME Expctd Del Fac Phn',     true),
    ('actual_delivery_facility',         'trisano.dw_morbidity_events_view', 'actual_delivery_facility',         'ME Actl Del Fac',        true),
    ('actual_delivery_facility_type',    'trisano.dw_morbidity_events_view', 'actual_delivery_facility_type',    'ME Actl Del Fac Typ',    true),
    ('actual_delivery_facility_phone',   'trisano.dw_morbidity_events_view', 'actual_delivery_facility_phone',   'ME Actl Del Fac Phn',    true),
    ('actual_delivery_date',             'trisano.dw_morbidity_events_view', 'actual_delivery_date',             'ME Actl Del Dt',         true),
    ('hcp_first_name',                   'trisano.dw_morbidity_events_view', 'hcp_first_name',                   'ME Hlth Care Prov Frst Nm', true),
    ('hcp_last_name',                    'trisano.dw_morbidity_events_view', 'hcp_last_name',                    'ME Hlth Care Prov Lst Nm',  true),
    ('hcp_middle_name',                  'trisano.dw_morbidity_events_view', 'hcp_middle_name',                  'ME Hlth Care Prov Mid Nm',  true),
    ('hcp_phones',                       'trisano.dw_morbidity_events_view', 'hcp_phones',                       'ME Hlth Care Prov Phone',   true);
}]
    queries.each do |q| conn.prepare_call(q).execute_update end
  end
end

class TriSano_metadata_plugin
  def initialize(conn, get_query_results)
    return PeriHepB_metadata.new conn, get_query_results
  end
end
