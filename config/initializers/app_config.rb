begin
  APP_CONFIG = YAML::load(ERB.new(IO.read(File.join(RAILS_ROOT, 'config', 'auth.yml'))).result)[RAILS_ENV]
rescue Exception => e
  puts "Central Log Viewer: HTTP Authentication not enabled"
  APP_CONFIG = { "is_enabled" => false }
end