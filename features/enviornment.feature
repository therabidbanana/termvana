Feature: Environment

  Background:
    Given I am on the home page

  Scenario: Setup can set home dir
    Given I start my server with environment:
      | variable |  value      |
      | HOME     | /tmp        |
    When I run "cd"
    And I run "pwd"
    Then I should get "/tmp"

  Scenario: Current working directory should show
    When I run "cd /tmp"
    Then my working directory should be "/tmp"
