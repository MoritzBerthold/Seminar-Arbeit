require_relative "rails"
include Rails

documents = {}
DATA.each_line do |line|
  p line
  if line.strip.empty?
  elsif line.start_with?('---')
    @name = line.delete! "-:\n\r"
    p "Adding new document #{@name}..."
    documents[@name] = ""
  else
    if documents[@name].nil?
      documents[@name] = ""
    end
    p "Adding #{line} to #{@name}..."
    documents[@name] += line
  end
end

#=begin
project = Project.new("blog",nil,nil,documents["routes.rb"])
articles_controller = Controller.new("Articles",["_form","show","view","edit"])
project.add_controller(articles_controller)
article_model = Model.new("Article",[Model_Field.new("title","string"),Model_Field.new("text","text")])
project.add_model(article_model)
generate(project)
#=end

documents.each do |name,content|
  if name.end_with?(".html.erb")
    path = "#{Dir.pwd}/app/views/articles"
  elsif name["controller"]
    path = "#{Dir.pwd}/app/controllers"
  elsif name["routes"]
    path = "#{Dir.pwd}/config"
  elsif name["article"]
    path = "#{Dir.pwd}/app/models"
  end
  Dir.open(path) do |dir|
    File.open(name,"w+") {|f| f.write(content)}
  end
end

=begin
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
=end

__END__
---routes.rb:
Rails.application.routes.draw do
  get 'welcome/index'
  resources :articles
  root "welcome#index"
end
---articles_controller.rb
class ArticlesController < ApplicationController
  def index
    @articles = Article.all
  end
  def show
    @article = Article.find(params[:id])
  end
  def new
    @article = Article.new
  end
  def edit
		@article = Article.find(params[:id])
	end
	def create
    @article = Article.new(article_params)
    if @article.save
      redirect_to @article
    else
      render 'new'
    end
  end
  def update
    @article = Article.find(params[:id])
    if @article.update(article_params)
      redirect_to @article
    else
      render 'edit'
    end
  end
  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    redirect_to articles_path
  end
  private
    def article_params
      params.require(:article).permit(:title, :text)
    end
end
---article.rb
class Article < ActiveRecord::Base
  validates :title, presence: true, length: { minimum: 5 }
end
---index.html.erb
<h1>Alle Beiträge</h1>
<%= link_to "Neuer Beitrag", new_article_path %>
<table>
  <tr>
    <th>Title</th>
    <th>Text</th>
  </tr>
  <% @articles.each do |article| %>
    <tr>
      <td><%= article.title %></td>
      <td><%= article.text %></td>
      <td><%= link_to 'Anzeigen', article_path(article) %></td>
      <td><%= link_to "Bearbeiten", edit_article_path(article) %></td>
      <td><%= link_to 'Destroy', article_path(article), method: :delete, data: { confirm: 'Are you sure?' } %></td>
    </tr>
  <% end %>
</table>
---_form.html.erb
<%= form_for :article, url: articles_path do |f| %>
  <% if @article.errors.any? %>
    <div id="error_explanation">
      <h2>
        <%= pluralize(@article.errors.count, "error") %> prohibited
        this article from being saved:
      </h2>
      <ul>
        <% @article.errors.full_messages.each do |msg| %>
          <li><%= msg %></li>
        <% end %>
      </ul>
    </div>
  <% end %>
  <p>
    <%= f.label :title %><br>
    <%= f.text_field :title %>
  </p>
  <p>
    <%= f.label :text %><br>
    <%= f.text_area :text %>
  </p>
  <p>
    <%= f.submit %>
  </p>
<% end%>
---show.html.erb
<h1>Beitrag</h1>
<p>
  <strong>Title:</strong>
  <%= @article.title %>
</p>
<p>
  <strong>Text:</strong>
  <%= @article.text %>
</p>
<%= link_to "Bearbeiten", edit_article_path(@article) %>
<%= link_to "Zurück", articles_path %>
---new.html.erb
<h1>Neuer Beitrag</h1>
<%= render "form" %>
<%= link_to "Zurück", articles_path %>
---edit.html.erb
<h1>Beitrag bearbeiten</h1>
<%= render "form" %>
<%= link_to 'Zurück', articles_path %>