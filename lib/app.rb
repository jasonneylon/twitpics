require "rubygems"
require "bundler/setup"
require "sinatra"
require "haml"
require "sass/plugin/rack"

use Sass::Plugin::Rack

require File.expand_path(File.join(File.dirname(__FILE__), "twitter_pictures"))

configure do
  set :views, File.expand_path(File.join(File.dirname(__FILE__), '..', 'views'))
  set :public, File.expand_path(File.join(File.dirname(__FILE__), '..', 'public'))
  set :haml, { :attr_wrapper => '"' }
end

configure :development do
  require 'sinatra/reloader'
  Sinatra::Application.also_reload "lib/**/*.rb"
end

get '/' do
  users = %w{jasonneylon javame pingles thattommyhall teabass surflogic malditogeek hemalkuntawala}
  @pictures = TwitterPictures.for_users(users)
  p @pictures
  haml :index
end


# search.containing("http").from("jasonneylon").result_type("recent").per_page(3).each do |r|
#   puts "#{r.from_user}: #{r.text}"
# end

