# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'erb'
require 'json'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

# Class for accessing data (memos)
class Memo
  def create_memo(title, body)
    id = SecureRandom.uuid
    hash = { id: id, title: title, body: body }
    Dir.mkdir('memos') unless File.exist?('memos')
    File.open("memos/#{id}.json", 'w') { |file| file.puts JSON.generate(hash) }
  end

  def load_all_memos
    files = Dir.glob('memos/*')
    file_datas = files.map { |file| File.read(file) }
    file_datas.map { |data| JSON.parse(data) }
  end

  def filepath(id)
    file_path = "/home/miki/sinatra/memos/"
    file_name = File.basename("memos/#{id}.json");
    @path = file_path + file_name
  end

  def file_open
    json = File.read(@path)
    data_hash = JSON.parse(json.to_json)
    JSON.parse(data_hash)
  end

  def rewrite_file(hash)
    File.open(@path, 'w') { |file| JSON.dump(hash, file) }
  end

  def delete_file
    File.delete(@path)
  end
end

not_found do
  'not found'
end

get '/memos' do
  @memos = Memo.new.load_all_memos

  erb :index
end

get '/memos/new' do
  erb :form
end

post '/memos' do
  Memo.new.create_memo(params[:title], params[:body])
  redirect to '/memos'
end

get '/memos/:id' do
  memo = Memo.new
  memo.filepath(params[:id])
  @hash = memo.file_open

  erb :show_memo
end

get '/memos/:id/edit' do
  memo = Memo.new
  memo.filepath(params[:id])
  @hash = memo.file_open

  erb :edit
end

patch '/memos/:id' do
  title = params[:title]
  body = params[:body]

  memo = Memo.new
  memo.filepath(params[:id])
  hash = memo.file_open

  if hash['body'] != body
    hash['body'] = body
    memo.rewrite_file(hash)
  end

  if hash['title'] != title
    hash['title'] = title
    memo.rewrite_file(hash)
  end

  redirect to "/memos/#{params[:id]}"
end

delete '/memos/:id' do
  memo = Memo.new
  memo.filepath(params[:id])
  memo.delete_file

  redirect to '/memos'
end
