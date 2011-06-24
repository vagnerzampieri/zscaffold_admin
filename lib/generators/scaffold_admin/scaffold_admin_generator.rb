require 'rails/generators/migration'
require 'rails/generators/generated_attribute'
require 'rails/generators/base'

class ScaffoldAdminGenerator < Rails::Generators::Base
  include Rails::Generators::Migration
  source_root File.expand_path("#{Rails.root}/lib/templates", __FILE__)
  
  no_tasks { attr_accessor :scaffold_name, :model_attributes }
  
  argument :scaffold_name, :type => :string, :required => true, :banner => 'Namespace/ModelName'
  argument :attributes, :type => :array, :default => [], :banner => 'field_name:type' 
  
  def create_templates
    args_attributes
    
    if namespace_name
      template "model.rb", "app/models/#{namespace_underscore}/#{singular_name}.rb"
      template "controller.rb", "app/controllers/#{namespace_underscore}/#{plural_name}_controller.rb"
      template "helper.rb", "app/helpers/#{namespace_underscore}/#{plural_name}_helper.rb"
      
      %w[index show edit new].each do |view|
        template "views/#{view}.html.erb", "app/views/#{namespace_underscore}/#{plural_name}/#{view}.html.erb"
      end      
      
      template "views/_form.html.erb", "app/views/#{namespace_underscore}/#{plural_name}/_form.html.erb"
      
    else
      template "model.rb", "app/models/#{singular_name}.rb"
      template "controller.rb", "app/controllers/#{plural_name}_controller.rb"
      template "helper.rb", "app/helpers/#{plural_name}_helper.rb"
      
      %w[index show edit new].each do |view|
        template "views/#{view}.html.erb", "app/views/#{plural_name}/#{view}.html.erb"
      end
      
      template "views/_form.html.erb", "app/views/#{namespace_underscore}/#{plural_name}/_form.html.erb"
      
    end
    
    route "resources :#{plural_name}"
  end
  
  def create_migration
    if namespace_name
      migration_template 'migration.rb', "db/migrate/create_#{namespace_underscore}_#{plural_name}.rb"
    else
      migration_template 'migration.rb', "db/migrate/create_#{plural_name}.rb"     
    end
  end

  def split_scaffold_name
    path = {}
    namespace = scaffold_name.split('/')
    path[:model_name] = namespace.pop
    path[:namespace] = namespace.pop
    path
  end
  
  def args_attributes
    @model_attributes = []
    
    attributes.each do |arg|
      if arg.include?(':')
        @model_attributes << Rails::Generators::GeneratedAttribute.new(*arg.split(':'))
      end
    end
    
    @model_attributes.uniq!
    
  end
  
  def model_name
    split_scaffold_name[:model_name]
  end
  
  def namespace_name
    split_scaffold_name[:namespace]
  end

  def singular_name
    model_name.underscore
  end
  
  def class_name
    model_name.titlecase.gsub(/[\-\/" "]/, "")
  end
  
  def plural_name
    model_name.underscore.pluralize
  end
  
  def plural_class
    class_name.pluralize
  end
  
  def module_name
    unless namespace_name.nil?
      namespace_name.titlecase.gsub(/[\-\/" "]/, "")
    end
  end
  
  def namespace_underscore
    unless namespace_name.nil?
      namespace_name.underscore
    end
  end
  
  protected
  no_tasks do
    # FIXME: Should be proxied to ActiveRecord::Generators::Base
    # Implement the required interface for Rails::Generators::Migration.
    def next_migration_number(dirname) #:nodoc:
      if ActiveRecord::Base.timestamped_migrations
        Time.now.utc.strftime("%Y%m%d%H%M%S")
      else
        "%.3d" % (current_migration_number(dirname) + 1)
      end
    end
  end
  
end
