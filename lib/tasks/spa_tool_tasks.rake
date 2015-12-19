require 'sprockets'
require_relative '../spa_tool/dynamo_manifest_list'

gem_spec = Gem::Specification.find_by_name 'sprockets'
require "#{gem_spec.gem_dir}/lib/rake/sprocketstask"

MANIFEST_FILES = %w( javascripts/application.js )
ASSET_INPUT_PATH = 'assets'
OUTPUT_PATH = './public'
DYNAMO_DB_NAME='travis-ci-example-with-filter'
DYNAMO_DB_REGION='eu-west-1'

namespace :spa_tools do
  def artifact_names
    Pathname.new('public/assets/javascripts')
      .children
      .select { |p| p.file? }
      .map { |p| p.split.last.to_s }
  end

  # make available rake tasks asset build, clean and clobber.
  Rake::SprocketsTask.new do |t|
    t.environment = Sprockets::Environment.new
    t.output      = [OUTPUT_PATH, ASSET_INPUT_PATH].join('/')
    t.assets      = MANIFEST_FILES

    t.environment.append_path ASSET_INPUT_PATH
  end

  desc "Compile assets"
  task :compile_assets do
    Rake::Task["assets"].invoke("assets")
  end

  desc "Put artifact file names on DynamoDB"
  task :put_artifact_names do
    DynamoManifestList.new(DYNAMO_DB_NAME, DYNAMO_DB_REGION).put(artifact_names)
  end

  desc "Get latest artifact file names from DynamoDB"
  task :get_latest_artifact_names do
    DynamoManifestList.new(DYNAMO_DB_NAME, DYNAMO_DB_REGION).get_latest
  end

  desc "Get created_at of the latest file names"
  task :get_latest_created_at do
    time = DynamoManifestList.new(DYNAMO_DB_NAME, DYNAMO_DB_REGION).get_latest_created_at
    p time
    time
  end

  task :testo do
    puts "testo"
  end

  desc "By default, run rake test"
  task :default => [ :compile_assets ]

end