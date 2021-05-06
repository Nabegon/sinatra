require 'sinatra'
require 'sinatra/reloader'
require 'erb'

get '/index' do
  @title = params['title']
  erb :index
end

get '/form' do
  erb :form
end

post '/index' do
  redirect "/index?title=#{params[:title]}"
end

get '/show_memo' do
  @title = params['title']
  @memo = params['memo']
  erb :show_memo
end

get '/edit' do
  erb :edit
end
# get '/erb_and_md_template_page' do
  # erb :erb_and_md_template_page, :locals => { :md => markdown(:erb_and_md_template_page) }
# end
