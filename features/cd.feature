Feature: CD
    
  Scenario: Change directory
    Given I am on the home page
    Given I move into the examples directory
    When I run "pwd"
    Then I should get the examples directory path

  Scenario: Change directory to home by default
    Given I am on the home page
    Given I run "cd"
    When I run "pwd"
    Then I should get my home path

  Scenario: Change directory to home's desktop with ~
    Given I am on the home page
    Given I run "cd ~/Desktop"
    When I run "pwd"
    Then I should get my home path with "Desktop" appended

  Scenario: Up a directory
    Given I am on the home page
    Given I run "cd ~/Desktop"
    And I run "cd .."
    When I run "pwd"
    Then I should get my home path

  Scenario: Down a directory
    Given I am on the home page
    Given I run "cd ~"
    And I run "cd Desktop"
    When I run "pwd"
    Then I should get my home path with "Desktop" appended

  Scenario: Same directory
    Given I am on the home page
    Given I run "cd ~"
    And I run "cd ."
    When I run "pwd"
    Then I should get my home path






