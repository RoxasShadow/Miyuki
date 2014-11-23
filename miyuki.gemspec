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
	s.files         = `git ls-files -z`.split("\0")
	s.require_path  = 'lib'
	s.executables   = 'miyuki'
	s.license       = 'WTFPL'

	s.add_dependency 'yamazaki',        '~> 0.3'
	s.add_dependency 'rufus-scheduler', '~> 3.0'
	s.add_dependency 'foreverb',        '~> 0.3'
end
