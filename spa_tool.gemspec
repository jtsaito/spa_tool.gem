# -*- encoding: utf-8 -*-

Gem::Specification.new do |spec|
  spec.name = 'spa_tool'
  spec.version = '0.0.1'
  spec.summary = 'Compile and upload assets for Single Pages Apps using Travis CI.'
  spec.description = <<-EOF
    This app is a tool for single page apps. When deploying a single page app
    three asset related tasks need to get done typlically: (1) compilation, (2)
    upload, and (3) the making available the names of the fingerprinted files.
    This gem exposes rake tasks for each of the three tasks. Asset are complied
    with Sprockets, uploaded to AWS S3 with Travis CI, and the fingerprints are
    stored in AWS DynamoDB for any backend to use the correct version.
  EOF
  spec.license = 'MIT'
  spec.authors = ['JT Saito']
  spec.email = 'jahn.saito@gmail.com'
  spec.homepage = 'https://github.com/jtsaito/spa_tool'

  spec.required_ruby_version = '>= 2.2.0'

  spec.files = Dir['lib/**/*.rb'].reverse
  spec.require_paths = ['lib']

  spec.add_dependency 'rake', '~> 10.4'
  spec.add_dependency 'sprockets', '~> 3.0'
  spec.add_dependency 'uglifier', '~> 2.7'
  spec.add_dependency 'coffee-script', '~> 2.4'
  spec.add_dependency 'bundler', '~> 1.10'
  spec.add_dependency 'aws-sdk', '~> 2.2'
  spec.add_dependency 'sass'

  spec.add_development_dependency 'pry-byebug', '~> 3.3'
  spec.add_development_dependency 'rspec', '~> 3.3'
  spec.add_development_dependency 'rubocop', '~> 0.9'
  spec.add_development_dependency 'simplecov', '~> 0.10'
end
