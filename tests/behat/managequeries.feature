@report @report_datawarehouse
Feature: Configuration of the Data warehouse report regarding queries
  In order to have my teachers export quiz data
  As an admin
  I need to manage the available queries

  @javascript
  Scenario: Add a first data warehouse report query
    Given I log in as "admin"
    And I navigate to "Reports > Data warehouse reports" in site administration
    And I press "Add new query"
    And I set the following fields to these values:
      | Name        | First query             |
      | Description | This is the first query |
      | Query       | First query             |
      | Enabled     | Yes                     |
    And I press "Save changes"
    Then I should see "First query"
    And I log out

  @javascript
  Scenario: Add a second quiz data warehouse report query
    Given I log in as "admin"
    And I navigate to "Reports > Data warehouse reports" in site administration
    And I press "Add new query"
    And I set the following fields to these values:
      | Name        | First query             |
      | Description | This is the first query |
      | Query       | First query             |
      | Enabled     | Yes                     |
    And I press "Save changes"
    And I press "Add new query"
    And I set the following fields to these values:
      | Name        | Second query             |
      | Description | This is the second query |
      | Query       | Second query             |
      | Enabled     | Yes                      |
    And I press "Save changes"
    Then I should see "First query"
    And I should see "Second query"
    And I log out

  @javascript
  Scenario: Delete a quiz data warehouse report query
    Given I log in as "admin"
    And I navigate to "Reports > Data warehouse reports" in site administration
    And I press "Add new query"
    And I set the following fields to these values:
      | Name        | First query             |
      | Description | This is the first query |
      | Query       | First query             |
      | Enabled     | Yes                      |
    And I press "Save changes"
    And I press "Add new query"
    And I set the following fields to these values:
      | Name        | Second query             |
      | Description | This is the second query |
      | Query       | Second query             |
      | Enabled     | Yes                      |
    And I press "Save changes"
    And I should see "First query"
    And I should see "Second query"
    And I click on "Delete" "link" in the "Second query" "table_row"
    And I should see "Are you sure you want to remove this query?"
    And I should see "Confirm query removal?"
    And I press "Yes"
    Then I should see "First query"
    And I should not see "Second query"
    And I log out

  @javascript
  Scenario: Modify a quiz data warehouse report query
    Given I log in as "admin"
    And I navigate to "Reports > Data warehouse reports" in site administration
    And I press "Add new query"
    And I set the following fields to these values:
      | Name        | First query             |
      | Description | This is the first query |
      | Query       | First query             |
      | Enabled     | Yes                      |
    And I press "Save changes"
    And I should see "First query"
    And I click on "Edit" "link" in the "First query" "table_row"
    And I set the following fields to these values:
      | Name        | First query (modified)             |
      | Description | This is the first query (modified) |
      | Query       | First query (modified)             |
      | Enabled     | No                                 |
    And I press "Save changes"
    And I click on "Edit" "link" in the "First query" "table_row"
    Then the following fields match these values:
      | Name        | First query (modified)             |
      | Description | This is the first query (modified) |
      | Query       | First query (modified)             |
      | Enabled     | No                                 |
    And I log out
