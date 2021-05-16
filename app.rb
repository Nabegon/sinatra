require 'sinatra'
require 'sinatra/reloader'
require 'erb'
require 'json'

get '/index' do
  @filenames = Dir.glob("*.json", base:Dir.pwd)
  
  erb :index
end

get '/form' do
  erb :form
end

post '/index' do
  @filenames = Dir.glob("*.json", base:Dir.pwd)
 
  title = params[:title]  
  hash = {"id" => SecureRandom.uuid,"title" => title,"body" => params[:body]}
  # hash["memo"] = []
  # hash["memo"].append({"id": SecureRandom.uuid, "title": title, "body": params[:body]})
  
  # File.open("#{title}.json", 'w') do |f|
  #   json_format = JSON.generate(hash, f)
  #   f.write(json_format)
  # end  
  # json_format = JSON.dump(hash, f)

  File.open("#{title}.json", 'w') do |file|
    file.puts JSON.generate(hash)
  end
  
  erb :index
end

get '/show_memo/:title' do
  @title = params['title']
  
  json = File.read("./#{@title}.json")
  data_hash = JSON.parse(json.to_json)
  # File.open("./#{@title}.json") do |f|
  #   hash = JSON.load(f)
  # end
  # data_hash = JSON.parse(hash.to_json)
  hash = JSON.parse(data_hash)
  @body = hash["body"]
  
  erb :show_memo
end

get '/edit' do
  erb :edit
end
