Feature: Load configuration file
  In order to load a custom configuration inside Miyuki
  As a user who wants to run her
  I give her the path to the configuration file

  Scenario: The file exists and is valid
    When I set the configuration file path to "features/support/miyuki.conf"
    Then I expect no exception raised

  Scenario: The file does not exist
    When I set the configuration file path to "features/support/nopls.conf"
    Then I expect an exception raised

  Scenario: The configuration is refreshed as soon as the file is modified
    When I set the configuration file path to "features/support/miyuki.conf"
    And  I modify something in "features/support/miyuki.conf"
    Then Miyuki reloads her configuration
    And  I get a notification about the reloading

  Scenario: Track files is updated in yamazaki when configuration file path is changed
    When I set the configuration file path to "features/support/miyuki.conf"
    And  I modify track file in "features/support/miyuki.conf"
    Then Miyuki reloads her configuration
    And  I invoke "track!"
    And  Yamazaki creates the new track file
    And  I modify track file in "features/support/miyuki.conf" #to restore the old miyuki.conf 
