Feature: Common tests types for lab results

  In order to simplify manual lab result entry
  Administrators need to be able to create common test types.

  Scenario: Listing common test types
    Given I am logged in as a super user
    And I have a common test type named Culture

    When I go to the common test type index page

    Then I should see a link to "Culture"
    And I should see "List Common Test Types"

  Scenario: Non-administrators tryiing to modify common test types
    Given I am logged in as an investigator
    When I go to the new common test type page
    Then I should get a 403 response

  Scenario: Creating a new common test type
    Given I am logged in as a super user

    When I go to the common test type index page
    And I press "Create New Common Test Type"

    Then I should see "Create a Common Test Type"
    And I should see a link to "< Back to Common Test Types"

    When I fill in "common_test_type_common_name" with "Culture"
    And I press "Create"

    Then I should see "Show a Common Test Type"
    And I should see "Culture"

  Scenario: Entering an invalid common name for common test type
    Given I am logged in as a super user
    And I have a common test type named Culture

    When I go to the new common test type page
    And I press "Create"
    Then I should see "Common name is too short"

    When I fill in "common_test_type_common_name" with "Culture"
    And I press "Create"
    Then I should see "Common name has already been taken"

  Scenario: Showing a common test type
    Given I am logged in as a super user
    And I have a common test type named Culture

    When I go to the common test type show page

    Then I should see a link to "< Back to Common Test Types"
    And I should see "Culture"
