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

module Miyuki
  class Notifier
    def initialize(notifier = nil)
      @notifier = notifier || get_notifier
    end

    def notify(title, message)
      @notifier.notify(title, message) if has_notifier?
    end

    def has_notifier?
      !!@notifier
    end

  private

    def get_notifier
      case RUBY_PLATFORM
        when /darwin/ then Miyuki::TerminalNotifier.new
        when /linux/  then Miyuki::Libnotify.new
      end
    end
  end
end
