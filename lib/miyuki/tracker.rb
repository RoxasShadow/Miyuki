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

      fetch_torrents

      @torrents.each do |torrent|
        downloaded = Yamazaki.download_torrent(torrent.title, torrent.link)

        @callback.call(torrent) if downloaded && @callback
      end
    end

    def remove_duplicates(other_torrents)
      @torrents.delete_if do |torrent|
        other_torrents.each do |other_torrent|
          return true if torrent.link == other_torrent.link
        end
      end
    end

  private

    def fetch_torrents
      @series.each do |series|
        pattern  = pattern_of(series)
        torrents = search(pattern)

        @torrents.concat(torrents.reverse)
      end
    end

    def pattern_of(series)
      pattern = series.fetch('pattern', '[$fansub] $name')

      pattern.scan(/\$[a-zA-Z_]*/).each do |var|
        pattern.gsub!(var, series[var[1..-1]]) if series.has_key?(var[1..-1])
      end

      pattern
    end
  end
end
