Story: Unfreeze externals
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