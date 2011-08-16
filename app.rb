require 'rubygems'
require 'sinatra'
require 'sinatra/respond_to'
require 'haml'
require 'lib/mobile_helpers'

# Register respond_to helper in order to get content negotiation
Sinatra::Application.register Sinatra::RespondTo

RBMobile::config do
  disable :ajax
end

# Register rbmobile helper
helpers RBMobile::Helpers

get '/' do
  respond_to do |format|
    format.html { haml :index }
  end
end
