$:.push File.dirname(__FILE__) + '/lib'
require 'acts_as_expirable/version'

Gem::Specification.new do |gem|
  gem.name = %q{acts_as_expirable}
  gem.authors = ["Jeff Ching"]
  gem.date = %q{2012-10-15}
  gem.description = %q{With ActsAsExpirable, you can mark ActiveRecord records as expired and programmatically find expired record.}
  gem.summary = "Basic expiry for Rails."
  gem.email = %q{ching.jeff@gmail.com}
  gem.homepage = 'http://github.com/chingor13/acts_as_expirable'

  gem.add_runtime_dependency 'rails', '~> 3.0'
  gem.add_development_dependency 'sqlite3'
  gem.add_development_dependency 'mysql2', '~> 0.3.7'

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "acts_as_expirable"
  gem.require_paths = ['lib']
  gem.version       = ActsAsExpirable::VERSION
end
