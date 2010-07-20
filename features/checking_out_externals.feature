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

  Scenario: Repository checked out then updated
    Given an external repository named 'first_external'
    And the externals are up to date
    And content is added to 'first_external'
    Then 'first_external' should not be up to date
    When I update the externals
    Then 'first_external' should be up to date

  Scenario: Two Repositories checked out and one updated
    Given an external repository named 'first_external'
    And an external repository named 'second_external'
    And the externals are up to date
    And content is added to 'first_external'
    And content is added to 'second_external'
    Then 'first_external' should not be up to date
    And 'second_external' should not be up to date
    When I update the external 'second_external'
    Then 'first_external' should not be up to date
    And 'second_external' should be up to date

  Scenario: One repo frozen, one repo unfrozen, and all updated
    Given an external repository named 'first_external'
    And an external repository named 'second_external'
    And the externals are up to date
    And the externals are frozen
    And content is added to 'first_external'
    And content is added to 'second_external'
    Then 'first_external' should not be up to date
    And 'second_external' should not be up to date
    When I unfreeze the external 'second_external'
    And I update the externals
    Then 'first_external' should not be up to date
    And 'second_external' should be up to date
