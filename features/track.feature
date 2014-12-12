Feature: Start the tracking of anime series
  In order to keep track of new episodes of the anime series I'm watching
  As user who wants to actually start Miyuki
  I call Miyuki::track!

  Scenario: The tracking starts without launching exceptions
    When I set the configuration file path to "features/support/miyuki.conf"
    And  I invoke "track!"
    Then I expect no exception raised
    And watch folder is created if it does not exists
    And watch folder is not created if it exists already
