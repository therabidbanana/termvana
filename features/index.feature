Feature: Index Page
  @javascript
  Scenario: Show me the page
    Given I am on the home page
    Then I should see "termvana" within "body"
