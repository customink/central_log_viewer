module Mongo
  class << self

    # Looks for configuration files in this order
    CONFIGURATION_FILES = ["central_logger.yml", "mongoid.yml", "database.yml"]

    def db
      @db ||= configure
    end

    def collection
      @collection
    end

    def configure
      @collection = "#{Rails.env}_log"
      config = {
        'host' => 'localhost',
        'port' => 27017 }.merge(resolve_config)
        
      db = Mongo::Connection.new(config['host'], config['port'], :auto_reconnect => true).db(config['database'])

      if config['username'] && config['password']
        # the driver stores credentials in case reconnection is required
        db.authenticate(config['username'], config['password'])
      end
      db
    end

    def resolve_config
      config = {}
      CONFIGURATION_FILES.each do |filename|
        config_file = Rails.root.join("config", filename)
        if config_file.file?
          config = YAML.load(ERB.new(config_file.read).result)[Rails.env]
          config = config['mongo'] if config.has_key?('mongo')
          break
        end
      end
      config
    end

  end
end
