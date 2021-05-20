require 'sinatra'
require 'sinatra/reloader'
require 'erb'
require 'json'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

not_found do
  'not found'
end

get '/memos' do
  files = Dir.glob('memos/*')
  file_datas = files.map { |file| File.read(file) }
  @hash = file_datas.map { |data| JSON.parse(data) }
   
  erb :index
end

get '/memos/new' do
  erb :form
end

post '/memos' do
  id =  SecureRandom.uuid
  hash = {id: id, title: params[:title], body: params[:body]}
  Dir.mkdir("memos") unless File.exists?("memos")
  File.open("memos/#{id}.json", 'w') { |file| file.puts JSON.generate(hash)}
  
  redirect to "/memos/#{id}"
end

def memo_file
  "memos/#{params[:id]}.json"
end

get '/memos/:id' do
  json = File.read(memo_file)
  data_hash = JSON.parse(json.to_json)
  @hash = JSON.parse(data_hash)

  erb :show_memo
end

get '/memos/:id/edit' do
  json = File.read(memo_file)
  data_hash = JSON.parse(json.to_json)
  @hash = JSON.parse(data_hash)
    
  erb :edit
end

patch '/memos/:id' do
  title = params[:title]
  body = params[:body]

  json = File.read(memo_file)
  data_hash = JSON.parse(json.to_json)
  hash = JSON.parse(data_hash)
    
  if hash["body"] != body
    hash["body"] = body
    File.open(memo_file, 'w') { |file| JSON.dump(hash, file) }
  end
   
  if hash["title"] != title
    hash["title"] = title
    File.open(memo_file, 'w') { |f| JSON.dump(hash, f) }
  end

  redirect to "/memos/#{params[:id]}"  
end

delete '/memos/:id' do
  File.delete(memo_file)
  
  redirect to "/memos"
end
