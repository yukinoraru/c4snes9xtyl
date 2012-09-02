require 'sinatra'
require 'sass'
require 'haml'
require 'json'
require './lib/cheat.rb'

set :public_folder, File.dirname(__FILE__) + '/public'

get '/download' do

  # deserialize cheat
  raw    = params["cheats"]
  cheats = Cheat.parse(raw)

  # check error if params[:check] is set
  if params[:check]
    content_type :json
    error = {}
    if cheats.length > 24
      error = {:error => "You can input only 24 cheats."}
    elsif cheats.length == 0
      error = {:error => "no valid cheats found."}
    else
      cheats.each_with_index{ |c, i|
        #p "kita#{i}/#{cheats.length}=#{c.validate}"
        if !c.validate
          error = {:error => "Some thing wrong with cheat No.#{i+1}"}
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
