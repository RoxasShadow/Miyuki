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
    attr_reader :config, :config_file
    attr_accessor :join_scheduler

    def config=(config_file)
      @notifier = Notifier.new

      @config_file = config_file
      @config = load_config

      Thread.new do
        FileWatcher.new(config_file).watch { refresh_config }
      end
    end

    def track!
      raise Exception, 'You have to provide a proper configuration file to start the tracking.' unless @config

      watch_dir = File.expand_path(@config['watchDir'])
      FileUtils.mkdir_p(watch_dir) unless Dir.exists?(watch_dir)

      track_file = File.expand_path(@config['trackFile'] || '~')

      config = DeepClone.clone(@config)
      @tracker = Tracker.new(watch_dir, track_file, config['series']) do |torrent|
        notify_torrents(torrent)
      end

      @tracker.refresh! && run_scheduler!
    end

  private

    def refresh_config
      new_config = load_config

      if @config != new_config
        notify_configuration

        @config = new_config
        track!
      end
    end

    def load_config
      YAML.load(File.read(@config_file))
    end

    def run_scheduler!
      @scheduled_job.kill if @scheduled_job

      scheduler = Rufus::Scheduler.new
      @scheduled_job = scheduler.schedule_every @config['refreshEvery'] { @tracker.refresh! }
      scheduler.join if @join_scheduler != false
    end

    def notify_torrents(torrent)
      if @config['notifications']['enabled']
        @notifier.notify(torrent.title, 'New episode released')
        sleep 1.1
      end
    end

    def notify_configuration
      if @config['notifications']['enabled']
        @notifier.notify('New configuration loaded in Miyuki', 'Changes detected in configuration file')
      end
    end
  end
end
