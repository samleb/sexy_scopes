module SexyScopesSpec
  extend self

  CONFIG_FILENAME = 'config.yml'
  EXAMPLE_CONFIG_FILENAME = 'config.example.yml'
  TRAVIS_CONFIG_FILENAME  = 'config.travis.yml'

  def config
    @config ||= read_config
  end

  protected
    def config_file
      File.expand_path("../#{config_filename}", File.dirname(__FILE__))
    end

    def config_filename
      ENV['TRAVIS'] ? TRAVIS_CONFIG_FILENAME : CONFIG_FILENAME
    end

    def example_config_file
      File.join(File.dirname(config_file), EXAMPLE_CONFIG_FILENAME)
    end

    def read_config
      unless File.exist?(config_file)
        FileUtils.cp example_config_file, config_file
      end

      YAML.load ERB.new(File.read(config_file)).result(binding)
    end

    def jruby?
      defined? JRUBY_VERSION
    end
end
