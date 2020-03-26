require_relative 'lib/shopping_cart_session/version'

Gem::Specification.new do |spec|
  spec.name          = "shopping_cart_session"
  spec.version       = ShoppingCartSession::VERSION
  spec.authors       = ["Laurence"]
  spec.email         = ["larfoley@yahoo.com"]

  spec.summary       = "A simple shopping cart gem"
  spec.description   = "Allows you to store a users shopping cart to the users session"
  spec.homepage      = "https://github.com/larfoley/shopping-cart-session"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")


  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/larfoley/shopping-cart-session"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rspec", "~> 3.2"
end
