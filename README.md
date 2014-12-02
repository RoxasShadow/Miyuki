Miyuki – Non ti lascia mai solo
===============================
After having configured the `example/miyuki.conf` configuration file, Miyuki lets you to have always the latest episodes of anime you're watching, downloading the episodes whenever they're available on Nyaa.

Of course, set the watch directory inside the configuration file to the one you've set in your torrent client.

Features
--------
- After having launched the daemon, changes to the configuration file will be always syncronized without having restart Miyuki
- Whenever Miyuki finds out a new episode to download, you'll be notified with an alert
- Miyuki gives you a powerful way to search anime series through patterns

Please note that, at the moment, the alert is only avaiable on Mac OSX 10.8 or higher. Linux users may want to wait a bit for libnotify support.

How to use
----------
`$ gem install miyuki`

`$ miyuki start example/miyuki.conf`

`$ miyuki stop` (or `$ miyuki kill`)

Configuration files when upgrading from miyuki 0.2 to 0.3
---------------------------------------------------------
Miyuki configurations files for 0.2 and 0.3 are a bit different, and some elaborations have to be done on the parsed files.
If you want to modify your config to enable some cool feature, please read the following notes:

- Notification are disabled by default, the sound is the default one (but you won't listen to it...)
- Mixing 0.2 and 0.3 configuration values
  Assuming you have a file like this,
  ```
  watchDir: /home/eli/idokidokiroxas
  configuration:
    - refreshEvery: 1h
    - watchDir: /home/winter/plsgo
  ```
  Miyuki will use `watchDir = /home/eli/idokidokiroxas` as watch directory because it's configured as required in 0.3.
  `refreshEvery` will be set to `1h` because Miyuki can't find a dedicate `refreshEvery` configuration and fallbacks to the 0.2 configuration style.
