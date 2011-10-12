require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'kaikifs')
require 'rspec'
require 'highline/import'
require 'active_support/inflector'
require 'yaml'

class KaikiFSWorld
    SHARED_PASSWORDS_FILE = "shared_passwords.yaml"
    username   = ENV['NETID']
    password   = ENV['PASSWORD']
    if File.exist? SHARED_PASSWORDS_FILE
      shared_passwords = File.open(SHARED_PASSWORDS_FILE) { |h| YAML::load_file(h) }
      puts shared_passwords
      if password.nil? and shared_passwords.keys.any? { |user| username[user] }
        user_group = shared_passwords.keys.select { |user| username[user] }[0]
        password = shared_passwords[user_group]
      end
    end
    username ||= ask("NetID:  ")    { |q| q.echo = true }
    password ||= ask("Password:  ") { |q| q.echo = "*" }
    env = 'dev'
    @@kaikifs = KaikiFS::Driver.new(username, password, :envs => [env])
    @@kaikifs.mk_screenshot_dir(File.join(Dir::pwd, 'features', 'screenshots'))
    @@kaikifs.start_session
    @@kaikifs.page.open "kfs-#{env}/portal.jsp"
    @@kaikifs.window_maximize
    @@kaikifs.login_via_webauth

    at_exit { @@kaikifs.stop }

  def kaikifs; @@kaikifs; end
end

World do
  KaikiFSWorld.new
end

After do |scenario|
  #puts scenario.instance_variables.sort
  #puts scenario.methods.sort
  #puts scenario.file_colon_line
  if scenario.failed?
    kaikifs.screenshot(scenario.file_colon_line.file_safe + '_' + Time.now.strftime("%Y%m%d%H%M%S"))
  end
end
