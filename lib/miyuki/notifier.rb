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
    
    def initialize
    end
   
    #based https://github.com/copiousfreetime/launchy/blob/master/lib/launchy/detect/host_os_family.rb
    def OS
      host_os = ::RbConfig::CONFIG['host_os']
      if host_os =~ /(mingw|mswin|windows|cygwin)/i
        return 'WINDOWS'
      elsif host_os =~ /(darwin|mac os)/i
        return 'MAC'
      elsif host_os =~ /(linux)/i
        return 'LINUX'
      else
        return 'UNKNOWN'
      end
    end
 
    def getNotifier
      operating_system = self.OS()
      if operating_system == 'MAC'
        return MacNotifier.new()
      elsif operating_system == 'LINUX'
        return LinuxNotifier.new()
      end
    end

    def notify(title, message, sound)
      puts ">using base class"
    end

  end
  

  class MacNotifier < Notifier
    def notify(title, message, sound)
      TerminalNotifier.notify(message, title: title, sound: sound)
    end

    def getNotifier
      self
    end
  end

  class LinuxNotifier < Notifier
    def notify(title, message, sound)
      #TODO: check if you can use sounds in Libnotify
      Libnotify.show(:body => message, :summary => title)
    end

    def getNotifier
      self
    end
  end
end
