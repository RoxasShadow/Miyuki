TROUBLESHOOTING (just in case)
==============================

## I did not install `libnotify` and I get `NoMethodError` ##

The easy fix is to disable notifications. 
If you get this error while executing `rake` or `rake test`, you may
want to `git apply features/support/turn_off_notifications.patch`
in order to automatize the process on the tests' configurations.
If you don't want to turn them off, either install `libnotify`
or wrap `@notifier.notify(title, message) if has_notifier?` line
inside `lib/miyuki/notifier.rb` inside a `begin ... rescue` block.
