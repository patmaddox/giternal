Story: Freeze externals
  As a developer
  I want to freeze externals
  So that I can test and deploy my app with no worries

  Scenario: Main project has one external
    Given an external repository named 'first_external'
    And the externals are up to date
    When I freeze the externals
    Then 'first_external' should no longer be a git repo
    And 'first_external' should be added to the commit index

  Scenario: External has been added to .gitignore
    Given an external repository named 'first_external'
    And the external 'first_external' has been added to .gitignore
    And the externals are up to date
    When I freeze the externals
    Then 'first_external' should be added to the commit index

