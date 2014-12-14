Miyuki – Non ti lascia mai solo
===============================
After having configured the `example/miyuki.conf` configuration file, Miyuki lets you to have always the latest episodes of anime you're watching, downloading the episodes whenever they're available on [nyaa](http://nyaa.se).

Of course, remember set the watch directory inside the configuration file (`example/miyuki.conf`) to the one you've set in your torrent client.

Features
--------
- After having launched the daemon, the changes to the configuration file will be always syncronized without having to restart Miyuki
- Whenever Miyuki finds out a new episode to download, you'll be notified with a system alert (compatible with OSX and Windows natively and with Linux installing `libnotify`)
- Miyuki gives you a powerful way to search anime series through patterns

How to use
----------
`$ gem install miyuki`

`$ miyuki start example/miyuki.conf`

`$ miyuki stop` (or `$ miyuki kill`)

Contributors
------------
- [alfateam123](https://github.com/alfateam123) — libnotify
