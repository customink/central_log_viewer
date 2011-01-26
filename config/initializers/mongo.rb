module Mongo
  class << self
    def db
      @db ||= configure
    end

    def collection
      @collection
    end

    def configure
      config_file = Rails.root.join("config", "database.yml")
      config = YAML.load(ERB.new(config_file.read).result)[Rails.env]
      config = { 'host' => 'localhost',
                 'port' => '27017' }.merge(config)
      @collection = config["collection"]
      Mongo::Connection.new(config['host'], config['port'], :auto_reconnect => true).db(config['database'])
    end
  end
end

