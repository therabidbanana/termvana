Feature: Index Page
    
  Scenario: Index page
    Given I am on the home page
    Then I should see "termvana" within "body"

  Scenario: Change directory
    Given I am on the home page
    Given I move into the examples directory
    When I run "pwd"
    Then I should get the examples directory path

