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

    def initialize(watch_dir, series, &callback)
      # TODO: This will raise a warning when the class is initializated twice
      Yamazaki.const_set(:WATCH_DIR, watch_dir)

      @series   = series || []
      @callback = callback if block_given?

      refresh
    end

    def for_every_torrent(&callback)
      if block_given?
        @callback = callback
      else
        yield
      end
    end

    def refresh
      @torrents = []

      fetch_torrents!

      @torrents.each do |torrent|
        downloaded = Yamazaki.download_torrent(torrent.title, torrent.link)

        @callback.call(torrent) if downloaded && @callback
      end
    end

    def remove_duplicates_from(other_torrents)
      other_torrents.delete_if do |torrent|
        @torrents.select { |other_torrent| torrent.link == other_torrent.link }.any?
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
