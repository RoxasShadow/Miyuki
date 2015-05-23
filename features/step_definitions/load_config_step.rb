When(/I set the configuration file path to "(.*)"/) do |path|
  @path = path
  begin
    Miyuki.config = @path
  rescue
  end
end

Then(/I expect an exception raised/) do
  expect { Miyuki.config = @path }.to raise_error
end

Then(/I expect no exception raised/) do
  expect { Miyuki.config = @path }.to_not raise_error
end

And(/^I modify something in "(.*?)"/) do |file|
  @previous_config = DeepClone.clone(Miyuki.config)

  config = File.read(file)

  if config.include?('6s')
    config.gsub!('6s', '5s')
  elsif config.include?('5s')
    config.gsub!('5s', '6s')
  end

  File.open(file, ?w) { |f| f.puts(config) }
end

And(/I modify track file in "(.*?)"/) do |file|
  @previous_config = DeepClone.clone(Miyuki.config)

  config = File.read(file)

  if config.include?('changedtrackfile.db')
    config.gsub!('changedtrackfile.db', '.miyuki.db')
  elsif config.include?('.miyuki.db')
    config.gsub!('.miyuki.db', 'changedtrackfile.db')
  end

  File.open(file, ?w) { |f| f.puts(config) }
end

And(/Yamazaki creates the new track file/) do
  expect {
    File.open('features/support/changedtrackfile.db')
  }.not_to raise_error 
end

Then(/^Miyuki reloads her configuration/) do
  expect(Miyuki.config).to_not be equal(@previous_config)
  expect(Miyuki.config['refreshEvery']).to_not be @previous_config['refreshEvery']
end
