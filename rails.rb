module Rails
  def generate(arg)
    if arg.is_a? Project
      project = arg
      puts "Generating project #{project.name}..."
      `rails new #{project.name}`
      Dir.chdir project.name
      project.controllers.each do |controller|
        generate(controller)
      end
      project.models.each do |model|
        generate(model)
      end
    elsif arg.is_a? Controller
      controller = arg
      puts "Generating controller #{controller.name}..."
      `rails generate controller #{controller.name+" "+controller.index}`
      Dir.open("#{Dir.pwd}/app/views/#{controller.name}") do |dir|
        controller.actions.each do |action|
          File.new("#{dir.path}/#{action}.html.erb", "w+")
        end
      end
    elsif arg.is_a? Model
      model = arg
      f = " "
      model.fields.each do |field|
        f << field.name + ":" + field.type + " "
      end
      puts "Generating model #{model.name}..."
      `rails generate model #{model.name + f}`
      puts "Migrating database..."
      `rake db:migrate`
    end
  end

  def server
    puts "Starting server..."
    `rails server &`
  end

  class Project
    attr_accessor :controllers, :models, :name, :configuration, :views
    @name
    @controllers
    @models
    @views
    @configuration

    def initialize(name, controllers, models, configuration)
      @name = String.new(name)
      if controllers.nil?
        @controllers = Array.new
      else
        @controllers = Array.new(controllers)
      end

      if models.nil?
        @models = Array.new
      else
        @models = Array.new(models)
      end

      if configuration.nil?
        @configuration = Configuration.new("")
      else
        @configuration = Configuration.new(configuration)
      end
    end

    def add_controller(controller)
      @controllers << controller
    end

    def add_model(model)
      @models << model
    end
  end

  class Controller
    attr_accessor :name, :actions, :index, :file
    @name
    @actions
    @file
    @index
    @count = 0
    class << self
      attr_accessor :count
    end

    def initialize(name, actions)
      self.class.count += 1
      @name = String.new(name)

      if actions.nil?
        @actions = Array.new
      else
        @actions = Array.new(actions)
      end
      @index = (@count == 1)?"index":""
    end


  end

  class Model
    attr_accessor :name, :fields, :file
    @name
    @fields
    @file

    def initialize(name, fields)
      @name = String.new(name)
      if fields.nil?
        @fields = Array.new
      else
        @fields = Array.new(fields)
      end
    end

    def add_model_field(model_field)
      @fields << model_field
    end
  end

  class Model_Field
    attr_accessor :name, :type
    @name
    @type

    def initialize(name, type)
      @name = String.new(name)
      @type = String.new(type)
    end
  end

  class Configuration
    @routes

    def initialize(routes)
      unless routes.nil?
        @routes = String.new(routes)
      end
    end
  end
end