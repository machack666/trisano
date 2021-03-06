Feature: Hep B specific pregnancy fields

  In order to properly manage perinatal Hep B cases, Epidemiologists
  need to be able to enter additional pregnancy information about
  woman /w Hepatitis B

  Scenario: Viewing a new cmr event
    Given I am logged in as a super user
     When I go to the new CMR page
     Then I should see "New CMR"
      And I should not see expected delivery fields
      And I should not see actual delivery fields

  Scenario: Editing an event w/ no disease specific fields
    Given I am logged in as a super user
      And a morbidity event exists with the disease African Tick Bite Fever
     When I go to edit the CMR
     Then I should see "Edit morbidity event"
      And I should not see expected delivery fields
      And I should not see actual delivery fields

  Scenario: Viewing an event w/ no disease specific fields
    Given I am logged in as a super user
      And a morbidity event exists with the disease African Tick Bite Fever
     When I go to view the CMR
     Then I should see "View Morbidity Event"
      And I should not see expected delivery data
      And I should not see actual delivery data


  Scenario: Entering expected delivery data
    Given I am logged in as a super user
      And a morbidity event exists with the disease Hepatitis B Pregnancy Event
      And "Hepatitis B Pregnancy Event" has disease specific core fields
     When I go to edit the CMR
     Then I should see expected delivery facility fields
     When I fill in "Expected delivery facility" with "Delivery Here Clinic"
      And I fill in "Expected delivery date" with "January 10, 2020"
      And I enter the expected delivery facility phone number as:
        | area_code | phone_number | extension |
        |       123 |     456-7890 |        88 |
      And I save the edit event form
     Then I should be on the show CMR page
      And I should see expected delivery data
      And I should see "Delivery Here Clinic"
      And I should see "2020-01-10"
      And I should see the expected delivery facility phone number as:
        | area_code | phone_number | extension |
        | (123)     |     456-7890 |        88 |
     When I go to print the Clinical CMR data
     Then I should see printed expected delivery fields
      And I should see printed expected delivery facility phone numbers:
        | Area code | Phone number | Extension |
        | (123)     |     456-7890 |        88 |

  Scenario: Entering actual delivery data
    Given I am logged in as a super user
      And a morbidity event exists with the disease Hepatitis B Pregnancy Event
      And "Hepatitis B Pregnancy Event" has disease specific core fields
     When I go to edit the CMR
     Then I should see actual delivery facility fields
     When I fill in "Actual delivery facility" with "Delivery Here Clinic"
      And I fill in "Actual delivery date" with "January 10, 2009"
      And I enter the actual delivery facility phone number as:
        | area_code | phone_number | extension |
        |       123 |     456-7890 |        88 |
      And I save the edit event form
     Then I should be on the show CMR page
      And I should see actual delivery data
      And I should see "Delivery Here Clinic"
      And I should see "2009-01-10"
      And I should see the actual delivery facility phone number as:
        | area_code | phone_number | extension |
        | (123)     |     456-7890 |        88 |
     When I go to print the Clinical CMR data
     Then I should see printed actual delivery fields
      And I should see printed actual delivery facility phone numbers:
        | Area code | Phone number | Extension |
        | (123)     |     456-7890 |        88 |

