TROUBLESHOOTING
===============

`NoMethodError` when running tests
----------------------------------
This *probably* means that you're under Linux or OSX and you have neither `libnotify` and `notifu`, respectively.
So, in order to make tests pass correctly, you may want to run `git apply features/support/turn_off_notifications.patch` in order to disable notificationss.
Otherwise, just install one of those two libraries and enjoy your life.
