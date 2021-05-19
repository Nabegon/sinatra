require 'sinatra'
require 'sinatra/reloader'
require 'erb'
require 'json'

get '/index' do
  files = Dir.glob("*.json", base:Dir.pwd)
  file_datas = files.map { |file| File.read(file) }
  @hash = file_datas.map { |line| JSON.parse(line) }
   
  erb :index
end

post '/index' do
  id =  SecureRandom.uuid
  hash = {id: id, title: params[:title], body: params[:body]}
  File.open("#{id}.json", 'w') { |file| file.puts JSON.generate(hash)}
  redirect '/index'
end

def file_name
  "./#{params[:id]}.json"
end

get '/show_memo/:id' do
  json = File.read(file_name)
  data_hash = JSON.parse(json.to_json)
  @hash = JSON.parse(data_hash)
  @id = params[:id]

  erb :show_memo
end

get '/edit/:id' do
  json = File.read(file_name)
  data_hash = JSON.parse(json.to_json)
  @hash = JSON.parse(data_hash)
    
  erb :edit
end

patch '/index/:id' do
  title = params[:title]
  body = params[:body]

  json = File.read(file_name)
  data_hash = JSON.parse(json.to_json)
  hash = JSON.parse(data_hash)
    
  if hash["body"] != body
    hash["body"] = body
    File.open(file_name, 'w') { |file| JSON.dump(hash, file) }
  end
   
  if hash["title"] != title
    hash["title"] = title
    File.open(file_name, 'w') { |f| JSON.dump(hash, f) }
  end

  redirect '/index'  
end
