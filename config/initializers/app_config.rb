begin
  APP_CONFIG = YAML::load(ERB.new(IO.read(File.join(Rails.root, 'config', 'auth.yml'))).result)[Rails.env]
rescue Exception => e
  puts "Central Log Viewer: HTTP Authentication not enabled"
  APP_CONFIG = { "authenticate" => false }
end