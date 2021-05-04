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

get '/new' do
  redirect "/index?title=#{params[:title]}"
  # redirect '/index'
  # erb :index
end
# get '/markdown_template_page' do
  # markdown :markdown_template_page
# end

# get '/erb_and_md_template_page' do
  # erb :erb_and_md_template_page, :locals => { :md => markdown(:erb_and_md_template_page) }
# end
