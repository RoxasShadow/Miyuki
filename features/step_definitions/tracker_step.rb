And(/I wait (\d+) seconds?/) do |seconds|
  sleep seconds.to_f
end

Then(/I have almost (\d+) torrent files? containing "(.+)"/) do |count, string|
  watch_dir = Miyuki.config['watchDir']
  torrent_files = Dir["#{watch_dir}/*.torrent"].select { |f| f.contains?(string) }

  expect(torrent_files.count).to be >= count.to_i
end

And(/I have almost (\d+) torrent files? that do not contain "(.+)"/) do |count, string|
  watch_dir = Miyuki.config['watchDir']
  torrent_files = Dir["#{watch_dir}/*.torrent"].reject { |f| f.contains?(string) }

  expect(torrent_files.count).to be >= count.to_i
end

And(/I have not the episodes? (.+) of "(.+)"/) do |episodes, string|
  watch_dir = Miyuki.config['watchDir']
  torrent_files = Dir["#{watch_dir}/*.torrent"].select { |f| f.contains?(string) }

  episodes = episodes.split(',').map(&:to_i)

  torrent_files.select! do |f|
    episode = f.scan(/- [0-9]*\.?[0-9]+/).flatten.last.to_i
    episodes.include?(episode)
  end

  expect(torrent_files.empty?).to be_truthy
end

And(/I have the episodes? (.+) of "(.+)"/) do |episodes, string|
  watch_dir = Miyuki.config['watchDir']
  torrent_files = Dir["#{watch_dir}/*.torrent"].select { |f| f.contains?(string) }
  torrent_files_count = torrent_files.length

  episodes = episodes.split(',').map(&:to_i)

  torrent_files.select! do |f|
    episode = f.scan(/- [0-9]*\.?[0-9]+/).flatten.last.to_i
    episodes.include?(episode)
  end

  expect(torrent_files.length).to_not be torrent_files_count
end

And(/there are (\d+) torrent files? containing "(.+)"/) do |count, string|
  watch_dir = Miyuki.config['watchDir']
  torrent_files = Dir["#{watch_dir}/*.torrent"].select { |f| f.contains?(string) }

  expect(torrent_files.count).to be count.to_i
end

And(/there are (\d+) torrent files? that do not contain "(.+)"/) do |count, string|
  watch_dir = Miyuki.config['watchDir']
  torrent_files = Dir["#{watch_dir}/*.torrent"].reject { |f| f.contains?(string) }

  expect(torrent_files.count).to be count.to_i
end

And(/there are some torrent files by "(.+)"/) do |fansub|
  watch_dir = Miyuki.config['watchDir']
  torrent_files = Dir["#{watch_dir}/*.torrent"].select { |f| f.include?("[#{fansub}]") }

  expect(torrent_files.any?).to be_truthy
end

And(/I consider the currently downloaded torrent files/) do
  watch_dir = Miyuki.config['watchDir']
  @previous_torrent_files_ctime = Dir["#{watch_dir}/*.torrent"].map { |f| File.ctime(f) }
end

Then(/I expect (\d+) torrent files? (have|has) been overwritten/) do |count, plural|
  watch_dir = Miyuki.config['watchDir']
  torrent_files_ctime = Dir["#{watch_dir}/*.torrent"].map { |f| File.ctime(f) }

  expect(@previous_torrent_files_ctime).to match_array(torrent_files_ctime)
end
