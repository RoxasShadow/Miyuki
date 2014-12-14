##
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
# Everyone is permitted to copy and distribute verbatim or modified
# copies of this license document, and changing it is allowed as long
# as the name is changed.
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
##

require 'fileutils'
require 'yaml'
require 'rufus-scheduler'
require 'yamazaki'
require 'filewatcher'
require 'deep_clone'

require 'miyuki/notifier'
require 'miyuki/tracker'
require 'miyuki/miyuki'
require 'miyuki/version'

case RUBY_PLATFORM
  when /darwin/ then require 'miyuki/notifiers/terminal-notifier.rb'
  when /linux/  then require 'miyuki/notifiers/libnotify.rb'
end
