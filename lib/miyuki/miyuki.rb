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
	class << self
		def config=(config_file)
			@config_file = config_file
			@config = load_config

                        @notifier = Notifier.getNotifier

			Rufus::Scheduler.singleton.every('10m') { refresh_config }
		end

		def track!
			watch_dir = File.expand_path(@config['watchDir'])
			FileUtils.mkdir_p(watch_dir) unless File.directory?(watch_dir)

			@tracker = Tracker.new(watch_dir, @config['series'])
			notify_torrents(@tracker.torrents)
			# We should find a way to avoid notifications for the torrents that already
			# exist and will not be downloaded (because of yamazaki) otherwise at every
			# refresh it will notify every torrent it has found.
			# However, notifications will start only *after* the torrents have been
			# downloaded, so threads would be cool for this.

			run_scheduler
		end

	private

		def refresh_config
			new_config = load_config

			if @config != new_config
				notify_configuration

				@config = new_config
				@scheduler.pause if defined?(@scheduler)
				track!
			end
		end

		def refresh_torrents
			old_torrents = @tracker.torrents

			@tracker.refresh

                        #TODO: restore this line (and delete @tracker#diff_with call) when
                        #      Yamazaki::Torrent comparison is implemented.
			#new_torrents = @tracker.torrents - old_torrents
                        new_torrents = @tracker.diff_with(old_torrents)
			notify_torrents(new_torrents)
		end

		def load_config
                        #support older configuration files that does not have "notification" section
			parsedConfig = YAML.load(File.read(@config_file))

                        unless parsedConfig['notifications'] then
                          parsedConfig['notifications'] = {'enabled' => false, 'sound' => 'default'}
                        end
                        unless parsedConfig['watchDir'] then
                          parsedConfig['watchDir'] = parsedConfig['configuration']['watchDir']
                        end
                        unless parsedConfig['refreshEvery'] then
                          parsedConfig['refreshEvery'] = parsedConfig['configuration']['refreshEvery']
                        end

                        return parsedConfig
		end

		def run_scheduler
			@scheduler = Rufus::Scheduler.new
			@scheduler.every @config['refreshEvery'] { refresh_torrents }
			@scheduler.join
		end

		def notify_torrents(torrents)
			torrents.each do |torrent|
                                @notifier.notify(torrent.title, 'New episode released', @config['notifications']['sound'])
				sleep 1.1
			end if @config['notifications']['enabled']
		end

		def notify_configuration
			if @config['notifications']['enabled']
                                @notifier.notify('New configuration loaded in Miyuki', 'Change detected in configuration file', @config['notifications']['sound'])
			end
		end
	end
end
