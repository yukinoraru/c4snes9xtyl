require 'sinatra'
require 'sass'
require 'haml'
require 'json'
require './cheat.rb'

set :public_folder, File.dirname(__FILE__) + '/public'

get '/download' do

  # deserialize cheat
  raw = params["cheat"]
  cheats = [
    Cheat.new("Shiawaseno udewa", "7E898401"),
    Cheat.new("Shiawaseno udewa", "7E898401"),
    Cheat.new("Shiawaseno udewa", "7E898401"),
    Cheat.new("Shiawaseno udewa", "7E898401"),
    Cheat.new("Shiawaseno udewa", "7E898401"),
  ]

  # check error if params[:check] is set
  if params[:check]
    content_type :json
    error = {}
    if cheats.length > 24
      error = {:error => "You can input only 24 cheats."}
    else
      cheats.each_with_index{ |c, i|
        if !c.validate()
          error = {:error => "Some thing wrong with No.#{i}."}
          break
        end
      }
    end
    if error.length == 0
      error = {:noc => cheats.length}
    end
    return error.to_json
  end

  # create .cht file
  filename = (params["filename"] =~ /^\w+$/) ? params["filename"] : "cheat"
  content_type = "application/octet-stream"
  response["Content-Disposition"] = "attachment; filename=#{filename}.cht"
  if params["debug"]
    response["Content-Disposition"] = ""
  end

  return cheats.reduce(""){|s, c|
    s += c.getbin() if c.validate()
  }

end

get '/' do
  haml :index
end

get '/style.css' do
  scss :style
end

get '/org.js' do
  coffee :org
end
