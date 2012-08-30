require 'sinatra'
require 'sass'
require 'haml'

set :public_folder, File.dirname(__FILE__) + '/public'
#set :environment, :production

get '/' do
  haml :index
end

get '/style.css' do
  scss :style
end

__END__

