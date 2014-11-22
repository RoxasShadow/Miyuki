##
# DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
# Version 2, December 2004
#
# Everyone is permitted to copy and distribute verbatim or modified
# copies of this license document, and changing it is allowed as long
# as the name is changed.
#
# DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
# TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
# 0. You just DO WHAT THE FUCK YOU WANT TO.
##

module Miyuki
	class << self
		def config=(config_file)
			@@config_file = config_file
			@@config = load_config

			Rufus::Scheduler.singleton.every('10m') { refresh_config! }
		end

		def track!
			watch_dir = File.expand_path(@@config['configuration']['watchDir'])
			@@tracker = Tracker.new(watch_dir, @@config['series'])

			run_scheduler
		end

	private

		def refresh_config!
			new_config = load_config

			if @@config != new_config
				@@config = new_config
				@@scheduler.pause if defined?(@@scheduler)
				track!
			end
		end

		def load_config
			YAML.load(File.read(@@config_file))
		end

		def run_scheduler
			@@scheduler = Rufus::Scheduler.new
			@@scheduler.every @@config['configuration']['refreshEvery'] do
			  old_torrents = @@tracker.torrents

			  @@tracker.refresh

			  new_torrents = @@tracker.torrents - old_torrents
			  if new_torrents.any?
			    puts 'New torrents:'
			    new_torrents.each { |torrent| puts torrent.to_s }
			  end
			end

			@@scheduler.join
		end
	end
end
