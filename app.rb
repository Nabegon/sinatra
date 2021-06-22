# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'erb'
require 'json'
require 'pg'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

# Class for accessing data (memos)
class Memo
  def initialize
    @connection = PG.connect(host: 'localhost', user: 'postgres', password: 'osushi', dbname: 'memos')
  end

  def create_memo(title, body)
    id = SecureRandom.uuid
    @connection.prepare("create_memo", "INSERT INTO memos VALUES ($1, $2, $3)")
    @connection.exec_prepared("create_memo", [id, title, body])
  end

  def load_all_memos
    @connection.prepare("load_all_memos", "SELECT * FROM memos")
    @connection.exec_prepared("load_all_memos")
  end

  def filepath(id)
    @id = id
  end

  def file_open
    @connection.prepare("file_open", "SELECT * FROM memos WHERE id = $1")
    @connection.exec_prepared("file_open", [@id])
  end

  def rewrite_file(title, body)
    @connection.prepare("update_file", "UPDATE memos SET (title, body) = ($1, $2) WHERE id = $3")
    @connection.exec_prepared("update_file", [title, body, @id])
  end

  def delete_file
    @connection.prepare("delete_file", "DELETE FROM memos WHERE id = $1")
    @connection.exec_prepared("delete_file", [@id])
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
  memo = Memo.new
  memo.filepath(params[:id])
  memo.rewrite_file(params[:title], params[:body])

  redirect to "/memos/#{params[:id]}"
end

delete '/memos/:id' do
  memo = Memo.new
  memo.filepath(params[:id])
  memo.delete_file

  redirect to '/memos'
end
