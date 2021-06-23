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

  def memo_id(id)
    @id = id
  end

  def load_memo
    @connection.prepare("load_memo", "SELECT * FROM memos WHERE id = $1")
    @connection.exec_prepared("load_memo", [@id])
  end

  def update_memo(title, body)
    @connection.prepare("update_memo", "UPDATE memos SET (title, body) = ($1, $2) WHERE id = $3")
    @connection.exec_prepared("update_memo", [title, body, @id])
  end

  def delete_memo
    @connection.prepare("delete_memo", "DELETE FROM memos WHERE id = $1")
    @connection.exec_prepared("delete_memo", [@id])
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
  memo.memo_id(params[:id])
  @hash = memo.load_memo

  erb :show_memo
end

get '/memos/:id/edit' do
  memo = Memo.new
  memo.memo_id(params[:id])
  @hash = memo.load_memo

  erb :edit
end

patch '/memos/:id' do
  memo = Memo.new
  memo.memo_id(params[:id])
  memo.update_memo(params[:title], params[:body])

  redirect to "/memos/#{params[:id]}"
end

delete '/memos/:id' do
  memo = Memo.new
  memo.memo_id(params[:id])
  memo.delete_memo

  redirect to '/memos'
end

