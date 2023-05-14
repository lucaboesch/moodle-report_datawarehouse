@report @report_datawarehouse
Feature: Run of the Data warehouse report
  In order to export Moodle data
  As a teacher or admin
  I need to trigger the available exports

  @javascript
  Scenario: Check data warehouse report capabilities
    Given the following "users" exist:
      | username | firstname | lastname | email                |
      | teacher1 | Teacher   | 1        | teacher1@example.com |
      | student1 | Student   | 1        | student1@example.com |
    And the following "courses" exist:
      | fullname | shortname | category |
      | Course 1 | C1        | 0        |
    And the following "course enrolments" exist:
      | user     | course | role           |
      | teacher1 | C1     | editingteacher |
      | student1 | C1     | student        |
    And I log in as "admin"
    And I set the following system permissions of "Authenticated user" role:
      | capability              | permission |
      | report/datawarehouse:view | Allow      |
    And I navigate to "Reports > Data warehouse reports" in site administration
    And I press "Add new query"
    And I set the following fields to these values:
      | Name        | First query             |
      | Description | This is the first query |
      | Query       | First query             |
      | Enabled     | Yes                     |
    And I press "Save changes"
    And I press "Add new backend"
    And I set the following fields to these values:
      | Name         | First backend             |
      | Description  | This is the first backend |
      | URL          | First backend             |
      | Username     | martin                    |
      | Password     | moodler                   |
      | Enabled      | Yes                       |
      | Allowed user | tim                       |
    And I press "Save changes"
    And I log out
    Given I log in as "teacher1"
    And I visit "/report/datawarehouse/index.php"
    And I should see "First query"
    And I should see "First backend"
    And "Edit" "icon" should not exist in the "First query" "table_row"
    And "Delete" "icon" should not exist in the "First query" "table_row"
    And "Edit" "icon" should not exist in the "First backend" "table_row"
    And "Delete" "icon" should not exist in the "First backend" "table_row"
    And I log out
    And I log in as "admin"
    And I navigate to "Reports > Data warehouse reports" in site administration
    Then I should see "First query"
    And I should see "First backend"
    And "Edit" "icon" should exist in the "First query" "table_row"
    And "Delete" "icon" should exist in the "First query" "table_row"
    And "Edit" "icon" should exist in the "First backend" "table_row"
    And "Delete" "icon" should exist in the "First backend" "table_row"
    And I log out
