When(/I invoke "(.*)"/) do |command|
  Miyuki.send(command.to_sym)
end

And(/watch folder is created if it does not exists/) do
  watch_dir = Miyuki.config['watchDir']
  FileUtils.rm_r(watch_dir) if Dir.exists?(watch_dir)

  track_file = Miyuki.config['trackFile']
  FileUtils.rm(track_file) if File.exists?(track_file)

  expect { Miyuki.track! }.to change { Dir.exists?(watch_dir) }.from(false).to(true)
end

And(/watch folder is not created if it exists already/) do
  watch_dir = Miyuki.config['watchDir']
  Dir.mkdir(watch_dir) unless Dir.exists?(watch_dir)

  expect { Miyuki.track! }.to_not change { Dir.exists?(watch_dir) }
end
