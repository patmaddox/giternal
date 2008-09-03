Feature: Checking out and updating externals
  As a developer
  I want to check out and update external projects via git
  So that I can add functionality to my app with little effort

  Scenario: Repository is not yet checked out
    Given an external repository named 'first_external'
    And 'first_external' is not yet checked out
    When I update the externals
    Then 'first_external' should be checked out

  Scenario: Multiple externals
    Given an external repository named 'first_external'
    And an external repository named 'second_external'
    When I update the externals
    Then 'first_external' should be checked out
    And 'second_external' should be checked out
