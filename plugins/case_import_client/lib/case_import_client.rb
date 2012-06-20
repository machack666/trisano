class CaseImportClient
#  SQL = <<-SQL
#     SELECT
#       e.id,
#       e.state_case_status_id ConditionStatus,
#       e."MMWR_year" MMWRYear,
#       e."MMWR_week" MMWRWeek,
#       e.record_number CDCID,
#       e.age_at_onset Age,
#       e.age_type_id AgeType,
#       a.state_id StateID,
#       a.county_id County,
#       p.ethnicity_id Ethnicity,
#       p.race_id Race
#      FROM events e
#      INNER JOIN participations ip ON (ip.event_id = e.id AND ip.type='InterestedParty')
#      INNER JOIN addresses a ON (a.event_id = e.id)
#      INNER JOIN people p ON p.entity_id = ip.primary_entity_id
#      LEFT JOIN external_codes age_type_codes ON e.age_type_id = age_type_codes.id
#      LEFT JOIN external_codes sex_codes ON p.birth_gender_id = sex_codes.id
#      LEFT JOIN external_codes state_case_status ON e.state_case_status_id = state_case_status.id
#      WHERE e.deleted_at IS NULL
#    SQL

    SQL = <<-SQL
     SELECT
       e.id,
       e.state_case_status_id ConditionStatus,
       e."MMWR_year" MMWRYear,
       e."MMWR_week" MMWRWeek,
       e.record_number CDCID,
       e.age_at_onset Age,
       e.age_type_id AgeType
      FROM events e
    SQL

  def self.start_import
    I18nLogger.info("#{Time.now} SOAP import started.")
    cases = ActiveRecord::Base.connection.execute SQL
    client = Savon::Client.new do
      wsdl.document = "https://apptrain.dhss.mo.gov/Xsentinel/surveillance/caseimportservice.svc/RS"
      http.headers = {
       "VsDebuggerCausalityData" => "uIDPoybVzgv4BJRAkI5qW2coL7QAAAAAdUasL934UkG0ahs2uDb+sFlsOQTmBBtFpJ4qjCt37vwACQAA"}
    end

    begin
    response = client.request "ImportPHCases" do
      soap.input = ["ImportPHCases", { "xmlns" => "http://www.stchome.com/marc/services/CaseImportService" } ]
      soap.element_form_default = :unqualified
      http.headers["SOAPAction"] = '"ImportPHCasesRequest"'
      soap.body do |xml|
        xml.tag! "source", "MOHSIS"
        xml.tag! "phCases", "xmlns:a" => "urn:Stchome:Marc:Wcf:CaseImportService:Data:v1", "xmlns:i" => "http://www.w3.org/2001/XMLSchema-instance" do |list|
          cases.each do |c|
            list.tag! "a:PHCase" do |node|
              node.tag! "a:OriginatingSystemId", "i:nil" => true
              node.tag! "a:ID", "11111120"
              node.tag! "a:Condition", "Cholera"
              node.tag! "a:EventDate", "2009-08-13"
              node.tag! "a:Travel", "No"
              node.tag! "a:Age", "19"
              node.tag! "a:AgeType", "Years"
              node.tag! "a:Sex", nil
              node.tag! "a:LPHA", "Cass County Health Department"
              node.tag! "a:Zip", "64742"
              node.tag! "a:ConditionStatus", "Died"
              node.tag! "a:BTHospitalRegion", "Cass County"
              node.tag! "a:CDCEnzymePattern1", nil
              node.tag! "a:CDCEnzymePattern2", nil
              node.tag! "a:CDCEnzymePattern3", nil
              node.tag! "a:CDCID", nil
              node.tag! "a:CDCPattern", nil
              node.tag! "a:City", nil
              node.tag! "a:Comments", nil
              node.tag! "a:County", "Cass"
              node.tag! "a:Ethnicity", "UnKnown"
              node.tag! "a:InvestigationStatus", nil
              node.tag! "a:Jurisdiction", nil
              node.tag! "a:LabReportDate", "2009-08-15"
              node.tag! "a:LabratoryName", nil
              node.tag! "a:MMWRWeek", "14"
              node.tag! "a:MMWRYear", "1995"
              node.tag! "a:OnsetDate", "2009-08-15"
              node.tag! "a:OrganismName", "Mycobacterium"
              node.tag! "a:OrganismSpecies", "cholarae"
              node.tag! "a:OtherStatePattern1", nil
              node.tag! "a:OtherStatePattern2", nil
              node.tag! "a:OtherStatePattern3", nil
              node.tag! "a:Outbreak", nil
              node.tag! "a:Race", "Asian"
              node.tag! "a:Region", nil
              node.tag! "a:Serogroup", nil
              node.tag! "a:Serotype", nil
              node.tag! "a:SpecimenCollectionDate", "2009-08-15"
              node.tag! "a:StateEnzymePattern1", nil
              node.tag! "a:StateEnzymePattern2", nil
              node.tag! "a:StateEnzymePattern3", nil
              node.tag! "a:StateID", "Kansas"
              node.tag! "a:StatePattern", nil
              node.tag! "a:TestName", nil
              node.tag! "a:RiskFactors", nil
            end
          end
        end
      end
    end
    I18nLogger.info(response.success?  ? "Successfully completed." : "Completed with errors.")
    pp response.success?
    rescue Savon::SOAP::Fault => fault
      I18nLogger.error(fault.to_s)
      pp fault
    end
  end
end