require 'yaml'

module SpaTool

  CONFIGURATION_FILE = '.spa_tool.yml'

  @config =
    {
      MANIFEST_FILES: [ 'javascripts/application.js' ],
      ASSET_INPUT_PATH: 'assets',
      OUTPUT_PATH: './public',
      DYNAMO_DB_NAME: 'travis-ci-example-with-filter',
      DYNAMO_DB_REGION: 'eu-west-1'
    }

  @valid_config_keys = @config.keys

  def self.configure(opts = {})
    opts.each {|k,v| @config[k.to_sym] = v if @valid_config_keys.include? k.to_sym}
  end

  def self.configure_from_yaml(yaml_file_name=CONFIGURATION_FILE)
    path_to_yaml_file = File.join(Dir.pwd, yaml_file_name).to_s

    begin
      config = YAML::load(IO.read(path_to_yaml_file))
    rescue Errno::ENOENT
      stderr.puts(:warning, "YAML configuration file couldn't be found. Using defaults."); return
    rescue Psych::SyntaxError
      stderr.puts(:warning, "YAML configuration file contains invalid syntax. Using defaults."); return
    end

    configure(config)
  end

  def self.config
    @config
  end

  def self.method_missing(*args)
    arg = args.first
    @valid_config_keys.include?(arg) ?  @config[arg] : super.method_missing(args)
  end

end
