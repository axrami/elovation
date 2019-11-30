# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)


class RootSiteAuth < Rack::Auth::Basic

  def isAdminPath(path)
    puts path
    admin = false
    blocked_paths = ['/games/new', '/players/new', '/results/new', '/edit']
    blocked_paths.each do |item|
      if admin == false
        admin = path.include? item
      end
    end
    return admin
  end

  def call(env)
    request = Rack::Request.new(env)
    if isAdminPath(request.path)
      puts 'blocked'
      super
    else
      puts 'passed'
      @app.call(env)
    end
  end
end

use RootSiteAuth, "Restricted Area" do |username, password|
  [username, password] == ['admin', 'admin!!99']
end

run Elovation::Application
