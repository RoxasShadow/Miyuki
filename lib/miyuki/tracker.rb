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

    def initialize(watch_dir, series)
      Yamazaki.const_set(:WATCH_DIR, watch_dir)

      @series = series || []

      refresh
    end

    def refresh
      @torrents = []

      fetch_torrents
      @torrents.each { |torrent| Yamazaki.download_torrent(torrent.title, torrent.link) }
    end

    def diff_with(other_torrents)
      #TODO: actually, it may be better to implement == in Yamazaki torrents and drop this function.
      def compare_torrents(a_torrent, b_torrent)
        a_torrent.title       == b_torrent.title       &&
        a_torrent.description == b_torrent.description &&
        a_torrent.link        == b_torrent.link        &&
        a_torrent.pub_date     == b_torrent.pub_date
      end
      @torrents.select { |torrent| 
        found = false
        other_i = 0
        while not found
          found = compare_torrents(torrent, other_torrents[other_i])
          other_i += 1
        end
        not found
      }
    end

  private

    def fetch_torrents
      @series.each do |series|
        pattern = pattern_of(series)
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
