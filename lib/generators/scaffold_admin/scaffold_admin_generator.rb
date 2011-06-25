require 'rails/generators/migration'
require 'rails/generators/generated_attribute'

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
      
      array_views.each do |view|
        template "views/#{view}.html.erb", "app/views/#{namespace_underscore}/#{plural_name}/#{view}.html.erb"
      end
      
    else
      template "model.rb", "app/models/#{singular_name}.rb"
      template "controller.rb", "app/controllers/#{plural_name}_controller.rb"
      template "helper.rb", "app/helpers/#{plural_name}_helper.rb"
      
      array_views.each do |view|
        template "views/#{view}.html.erb", "app/views/#{plural_name}/#{view}.html.erb"
      end
      
    end
    
    route "resources :#{plural_name}"
  end
  
  def create_migration
    migration_number = Time.now.strftime('%Y%m%d%H%M%S')
    if namespace_name
      template 'migration.rb', "db/migrate/#{migration_number}_create_#{namespace_underscore}_#{plural_name}.rb"
    else
      template 'migration.rb', "db/migrate/#{migration_number}_create_#{plural_name}.rb"
    end
  end
  
  def array_views
    %w[edit _form index new show]
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
  
end
