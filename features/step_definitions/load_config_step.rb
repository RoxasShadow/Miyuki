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
  @previous_config = Miyuki.config

  FileUtils.touch(file)
end

Then(/^Miyuki reloads her configuration/) do
  expect(Miyuki.config).to_not be equal(@previous_config)
end
