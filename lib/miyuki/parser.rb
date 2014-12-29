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
  module Parser
    class << self
      def parse(series)
        pattern = series.fetch('pattern', '[$fansub] $name')

        pattern.scan(/\$[a-zA-Z_]*/).each do |var|
          pattern.gsub!(var, series[var[1..-1]]) if series.has_key?(var[1..-1])
        end

        pattern
      end

      def filter_episodes!(torrents, from_episode, keep = true)
        range = from_episode..1.0/0

        if range
          torrents.select! do |torrent|
            return keep unless torrent.title

            episode = torrent.title.scan(/- [0-9]*\.?[0-9]+/).last
            episode = episode.scan(/[0-9]*\.?[0-9]+/).last if episode
            episode = episode[1..-1] if episode && episode[0] == '0'

            if episode
              is_integer?(episode) ? range.include?(episode.to_i) : keep
            else
              keep
            end
          end
        end
      end

    private

      def is_integer?(string)
        string.to_i.to_s == string
      end
    end
  end
end
