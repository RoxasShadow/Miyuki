Kernel.load 'lib/miyuki/version.rb'

Gem::Specification.new do |s|
  s.name          = 'miyuki'
  s.version       = Miyuki::VERSION
  s.author        = 'Roxas Shadow'
  s.email         = 'webmaster@giovannicapuano.net'
  s.homepage      = 'https://github.com/RoxasShadow/Miyuki'
  s.platform      = Gem::Platform::RUBY
  s.summary       = 'Miyuki allows you to not miss any episode of anime you\'re watching'
  s.description   = 'Miyuki downloads automatically every episode of anime you\'re watching'
  s.files         = Dir['README.md', 'Gemfile', 'Rakefile', '{bin,example,features,lib}/**/*']
  s.require_path  = 'lib'
  s.executables   = 'miyuki'
  s.license       = 'WTFPL'

  s.add_dependency 'yamazaki'
  s.add_dependency 'rufus-scheduler'
  s.add_dependency 'foreverb'
  s.add_dependency 'filewatcher'
  s.add_dependency 'ruby_deep_clone'

  case RUBY_PLATFORM
    when /darwin/ then s.add_dependency 'terminal-notifier'
    when /linux/  then s.add_dependency 'libnotify'
    when /mswin|msys|mingw|cygwin/ then s.add_dependency 'rb-notifu'
  end

  s.add_development_dependency 'cucumber'
  s.add_development_dependency 'rspec'
end
