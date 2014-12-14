Feature: Download new episodes
  In order to download the new episodes of the anime series I'm watching
  As user who wants to have the torrent files downloaded automatically as soon as they're available
  I expect the episodes are tracked and the torrent files are downloaded

  Scenario: The episodes are downloaded according to the configuration file
    When I set the configuration file path to "features/support/miyuki.conf"
    And  I invoke "track!"
    And  I wait 5 seconds to let Miyuki to find and download the episodes
    Then I have almost 2 torrent files containing "Nisekoi BD"
    And  I have almost 4 torrent files that do not contain "BD Nisekoi"
    And  I have not the episodes 1, 4, 8 of "Mekakucity"
    And  I have the episode 9, 10 of "Mekakucity"
    And  there are 0 torrent files containing "Nisekoi 720p"
    And  there are 0 torrent files that do not contain "[Commie]"

  Scenario: Episodes already downloaded are ignored
    When I set the configuration file path to "features/support/miyuki.conf"
    And  I invoke "track!"
    And  I wait 5 seconds to let Miyuki to find and download the episodes
    And  I consider the currently downloaded torrent files
    And  I wait 6 seconds in order to have a new check of the new anime episodes
    And  I wait 5 seconds in case this scenario would fail
    Then I expect 0 torrent files have been overwritten by their duplicates

  Scenario: There is a notification for every episode downloaded if enabled
    When I set the configuration file path to "features/support/miyuki.conf"
    And  I invoke "track!"
    Then I get a notification for every torrent file downloaded
