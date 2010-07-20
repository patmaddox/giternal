Feature: Unfreeze externals
  As a developer
  I want to unfreeze externals
  So that I can continue to update and develop on them

  Scenario: Main project has one frozen external
    Given an external repository named 'first_external'
    And the externals are up to date
    And the externals are frozen
    When I unfreeze the externals
    Then 'first_external' should be a git repo
    And 'first_external' should be removed from the commit index

  Scenario: Main project has two frozen externals
    Given an external repository named 'first_external'
    And an external repository named 'second_external'
    And the externals are up to date
    And the externals are frozen
    When I unfreeze the external 'second_external'
    Then 'second_external' should be a git repo
    And 'second_external' should be removed from the commit index
    And 'first_external' should no longer be a git repo
    And 'first_external' should be added to the commit index
