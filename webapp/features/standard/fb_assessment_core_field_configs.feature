Feature: Assessment event form core field configs

  To allow for a more relevant event form
  An investigator should see core field configs on a assessment form

  Scenario: Assessment event core field configs
    Given I am logged in as a super user
      And a assessment event form exists
      And that form has core field configs configured for all core fields
      And that form is published
      And a assessment event exists with a disease that matches the form
     When I am on the AE edit page
      And I answer all core field config questions
      And I save the event
     Then I should see all of the core field config questions
      And I should see all core field config answers
