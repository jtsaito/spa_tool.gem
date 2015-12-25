require 'sprockets'
require_relative '../spa_tool/dynamo_manifest_list'
require_relative '../spa_tool/config'

SpaTool.configure_from_yaml

gem_spec = Gem::Specification.find_by_name 'sprockets'
require "#{gem_spec.gem_dir}/lib/rake/sprocketstask"

# make available rake tasks asset build, clean and clobber
# in global rake task name space
Rake::SprocketsTask.new do |t|
  t.environment = Sprockets::Environment.new
  t.output      = [SpaTool.OUTPUT_PATH, SpaTool.ASSET_INPUT_PATH].join('/')
  t.assets      = SpaTool.MANIFEST_FILES

  t.environment.append_path SpaTool.ASSET_INPUT_PATH
end

namespace :spa_tools do
  def artifact_names
    Pathname.new('public/assets/javascripts')
      .children
      .select { |p| p.file? }
      .map { |p| p.split.last.to_s }
  end

  desc "Compile assets from input repo directory save in output directory"
  task :compile do
    Rake::Task["assets"].invoke("assets")
  end

  desc "Put artifact file names on DynamoDB"
  task :put_artifact_names do
    DynamoManifestList.new(SpaTool.DYNAMO_DB_NAME, SpaTool.DYNAMO_DB_REGION).put(artifact_names)
  end

  desc "Get latest artifact file names from DynamoDB"
  task :get_latest_artifact_names do
    DynamoManifestList.new(SpaTool.DYNAMO_DB_NAME, SpaTool.DYNAMO_DB_REGION).get_latest
  end

  desc "Get created_at of the latest file names"
  task :get_latest_created_at do
    time = DynamoManifestList.new(SpaTool.DYNAMO_DB_NAME, SpaTool.DYNAMO_DB_REGION).get_latest_created_at
    p time
    time
  end

  desc "By default, run rake test"
  task :default => [ :compile_assets ]

end
