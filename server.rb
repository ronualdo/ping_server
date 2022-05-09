# frozen_string_literal: true

require 'sinatra'
require 'sinatra/json'

get '/ping' do
  json result: 'pong'
end
