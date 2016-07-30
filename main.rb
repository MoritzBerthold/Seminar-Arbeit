puts "Generating project..."
`rails new blog`

Dir.chdir "blog"

puts "Generating controller..."
`rails generate controller Articles index`
Dir.open("#{Dir.pwd}/app/controllers") do |dir|
  File.open("#{dir.path}/articles_controller.rb", "w+") do |f|
    f.puts("class ArticlesController < ApplicationController")
    f.puts("def index")
    f.puts("@articles = Article.all")
    f.puts("end")
    f.puts("def show")
    f.puts("@article = Article.find(params[:id])")
    f.puts("end")
    f.puts("def new")
    f.puts("@article = Article.new")
    f.puts("end")
    f.puts("def edit")
    f.puts("@article = Article.find(params[:id])")
    f.puts("end")
    f.puts("def create")
    f.puts("@article = Article.new(article_params)")
    f.puts("if @article.save")
    f.puts("redirect_to @article")
    f.puts("else")
    f.puts("render 'new'")
    f.puts("end")
    f.puts("end")
    f.puts("def update")
    f.puts("@article = Article.find(params[:id])")
    f.puts("if @article.update(article_params)")
    f.puts("redirect_to @article")
    f.puts("else")
    f.puts("render 'edit'")
    f.puts("end")
    f.puts("end")
    f.puts("def destroy")
    f.puts("@article = Article.find(params[:id])")
    f.puts("@article.destroy")
    f.puts("redirect_to articles_path")
    f.puts("end")
    f.puts("private")
    f.puts("def article_params")
    f.puts("params.require(:article).permit(:title, :text)")
    f.puts("end")
    f.puts("end")
  end
end

Dir.open("#{Dir.pwd}/app/views/articles") do |dir|
  File.open("#{dir.path}/index.html.erb","w+") do |f|
    f.puts("<h1>Alle Beiträge</h1>")
    f.puts("<%= link_to 'Neuer Beitrag', new_article_path %>")
    f.puts("<table>")
    f.puts("<tr>")
    f.puts("<th>Title</th>")
    f.puts("<th>Text</th>")
    f.puts("</tr>")
    f.puts("<% @articles.each do |article| %>")
    f.puts("<tr>")
    f.puts("<td><%= article.title %></td>")
    f.puts("<td><%= article.text %></td>")
    f.puts("<td><%= link_to 'Anzeigen', article_path(article) %></td>")
    f.puts("<td><%= link_to 'Bearbeiten', edit_article_path(article) %></td>")
    f.puts("<td><%= link_to 'Destroy', article_path(article), method: :delete, data: { confirm: 'Are you sure?' } %></td>")
    f.puts("</tr>")
    f.puts("<% end %>")
    f.puts("</table>")
  end

  File.open("#{dir.path}/_form.html.erb","w+") do |f|
    f.puts("<%= form_for :article, url: articles_path do |f| %>")
    f.puts("<% if @article.errors.any? %>")
    f.puts("<div id=\"error_explanation\">")
    f.puts("<h2>")
    f.puts("<%= pluralize(@article.errors.count, \"error\") %> prohibited")
    f.puts("this article from being saved:")
    f.puts("</h2>")
    f.puts("<ul>")
    f.puts("<% @article.errors.full_messages.each do |msg| %>")
    f.puts("<li><%= msg %></li>")
    f.puts("<% end %>")
    f.puts("</ul>")
    f.puts("</div>")
    f.puts("<% end %>")
    f.puts("<p>")
    f.puts("<%= f.label :title %><br>")
    f.puts("<%= f.text_field :title %>")
    f.puts("</p>")
    f.puts("<p>")
    f.puts("<%= f.label :text %><br>")
    f.puts("<%= f.text_area :text %>")
    f.puts("</p>")
    f.puts("<p>")
    f.puts	("<%= f.submit %>")
    f.puts("</p>")
    f.puts("<% end%>")
  end

  File.open("#{dir.path}/show.html.erb","w+") do |f|
    f.puts("<h1>Beitrag</h1>")
    f.puts("<p>")
    f.puts("<strong>Title:</strong>")
    f.puts  ("<%= @article.title %>")
    f.puts("</p>")
    f.puts("<p>")
    f.puts("<strong>Text:</strong>")
    f.puts ("<%= @article.text %>")
    f.puts("</p>")
    f.puts("<%= link_to 'Bearbeiten', edit_article_path(@article) %>")
    f.puts("<%= link_to 'Zurück', articles_path %>")
  end

  File.open("#{dir.path}/new.html.erb","w+") do |f|
    f.puts("<h1>Neuer Beitrag</h1>")
    f.puts("<%= render 'form' %>")
    f.puts("<%= link_to 'Zurück', articles_path %>")
  end

  File.open("#{dir.path}/edit.html.erb","w+") do |f|
    f.write("<h1>Neuer Beitrag</h1>")
    f.puts("<%= render 'form' %>")
    f.puts("<%= link_to 'Zurück', articles_path %>")
  end
end

puts "Generating model..."
`rails generate model Article title:string text:text`

Dir.open("#{Dir.pwd}/app/models") do |dir|
  File.open("#{dir.path}/article.rb", "w+") do |f|
    f.puts("class Article < ActiveRecord::Base")
    f.puts("validates :title, presence: true, length: { minimum: 5 }")
    f.puts("end")
  end
end

puts "Migrating database..."
`rake db:migrate`

Dir.open("#{Dir.pwd}/config") do |dir|
  File.open("#{dir.path}/routes.rb", "w+") do |f|
    f.puts("Rails.application.routes.draw do")
    f.puts("get 'articles/index'")
    f.puts("resources :articles")
    f.puts("root 'articles#index'")
    f.puts("end")
  end
end

puts "Starting server..."
`rails server &`