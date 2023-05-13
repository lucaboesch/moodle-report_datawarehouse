@report @report_datawarehouse
Feature: Configuration of the Data warehouse report regarding backends
  In order to have my teachers export quiz data
  As an admin
  I need to manage the available backends

  @javascript
  Scenario: Add a first quiz data warehouse report backend
    Given I log in as "admin"
    And I navigate to "Reports > Data warehouse reports" in site administration
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
    Then I should see "First backend"
    And I log out

  @javascript
  Scenario: Add a second quiz data warehouse report backend
    Given I log in as "admin"
    And I navigate to "Reports > Data warehouse reports" in site administration
    And I press "Add new backend"
    And I set the following fields to these values:
      | Name         | First backend             |
      | Description  | This is the first backend |
      | URL          | https://moodle.org/       |
      | Username     | martin                    |
      | Password     | moodler                   |
      | Enabled      | Yes                       |
      | Allowed user | tim                       |
    And I press "Save changes"
    And I press "Add new backend"
    And I set the following fields to these values:
      | Name         | Second backend             |
      | Description  | This is the second backend |
      | URL          | https://moodle.com/        |
      | Username     | tim                        |
      | Password     | open                       |
      | Enabled      | Yes                        |
      | Allowed user | tim, martin                |
    And I press "Save changes"
    Then I should see "First backend"
    And I should see "Second backend"
    And I log out

  @javascript
  Scenario: Delete a quiz data warehouse report backend
    Given I log in as "admin"
    And I navigate to "Reports > Data warehouse reports" in site administration
    And I press "Add new backend"
    And I set the following fields to these values:
      | Name         | First backend             |
      | Description  | This is the first backend |
      | URL          | https://moodle.org/       |
      | Username     | martin                    |
      | Password     | moodler                   |
      | Enabled      | Yes                       |
      | Allowed user | tim                       |
    And I press "Save changes"
    And I press "Add new backend"
    And I set the following fields to these values:
      | Name         | Second backend             |
      | Description  | This is the second backend |
      | URL          | https://moodle.com/        |
      | Username     | tim                        |
      | Password     | open                       |
      | Enabled      | Yes                        |
      | Allowed user | tim, martin                |
    And I press "Save changes"
    And I should see "First backend"
    And I should see "Second backend"
    And I click on "Delete" "link" in the "Second backend" "table_row"
    And I should see "Are you sure you want to remove this backend?"
    And I should see "Confirm backend removal?"
    And I press "Yes"
    Then I should see "First backend"
    And I should not see "Second backend"
    And I log out

  @javascript
  Scenario: Modify a quiz data warehouse report backend
    Given I log in as "admin"
    And I navigate to "Reports > Data warehouse reports" in site administration
    And I press "Add new backend"
    And I set the following fields to these values:
      | Name         | First backend             |
      | Description  | This is the first backend |
      | URL          | https://moodle.org/       |
      | Username     | martin                    |
      | Password     | moodler                   |
      | Enabled      | Yes                       |
      | Allowed user | tim                       |
    And I press "Save changes"
    And I should see "First backend"
    And I click on "Edit" "link" in the "First backend" "table_row"
    And I set the following fields to these values:
      | Name         | First backend (modified)             |
      | Description  | This is the first backend (modified) |
      | URL          | https://moodledev.io/                |
      | Username     | tim                                  |
      | Password     | martin                               |
      | Enabled      | No                                   |
      | Allowed user | tim, martin                          |
    And I press "Save changes"
    And I click on "Edit" "link" in the "First backend" "table_row"
    Then the following fields match these values:
      | Name         | First backend (modified)             |
      | Description  | This is the first backend (modified) |
      | URL          | https://moodledev.io/                |
      | Username     | tim                                  |
      | Password     | martin                               |
      | Enabled      | No                                   |
      | Allowed user | tim, martin                          |
    And I log out
