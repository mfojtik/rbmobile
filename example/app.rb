require 'rubygems'
require 'sinatra'
require 'sinatra/respond_to'
require 'haml'

# Try gem first, then assume that this app is started from the examples folder
# and require helpers from parent folder.
begin
  require 'mobile_helpers'
rescue LoadError
  require '../lib/mobile_helpers'
end

# Register respond_to helper in order to get content negotiation
Sinatra::Application.register Sinatra::RespondTo

# I don't like the fancy AJAX navigation too much
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
