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
  class Tracker
    include Yamazaki::Core

    attr_reader :torrents

    def initialize(watch_dir, track_file, series, &callback)
      Yamazaki.class.instance_eval do # breaking the rules is so funny sometimes w
        remove_const(:WATCH_DIR) if const_defined?(:WATCH_DIR)
        const_set(:WATCH_DIR, watch_dir)

        remove_const(:TRACK_FILE) if const_defined?(:TRACK_FILE)
        const_set(:TRACK_FILE, track_file)
      end

      Yamazaki.load_database

      @series   = series || []
      @callback = callback if block_given?
    end

    def for_every_torrent(&callback)
      if block_given?
        @callback = callback
      else
        yield
      end
    end

    def refresh!
      old_torrents = @torrents || []

      @torrents = []

      fetch_torrents!
      @torrents -= old_torrents

      @torrents.each do |torrent|
        downloaded = Yamazaki.download_torrent(torrent.title, torrent.link)

        @callback.call(torrent) if downloaded && @callback
      end
    end

  private

    def fetch_torrents!
      @series.each do |series|
        query = URI.encode_www_form_component(Parser.parse(series)) # TODO: move encode to yamazaki?
        torrents = search(query)
        torrents.each { |torrent| torrent.title.gsub!(/_/, ' ') }

        episodes = series['episodes']
        if episodes && episodes['from']
          Parser.filter_episodes!(torrents, episodes['from'], episodes['skipIfNotSure'] == true)
        end

        @torrents.concat(torrents.reverse)
      end
    end
  end
end
