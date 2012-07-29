module ScaffoldAdmin
  class InstallGenerator < Rails::Generators::Base
    desc 'Copy files for configuration ZScaffold Admin'

    def self.source_root
      @_install_source_root ||= File.expand_path("../templates", __FILE__)
    end

    def copy_files
      gem 'will_paginate'

      copy_file "config/initializers/will_paginate.rb", "config/initializers/will_paginate.rb"

      array_classes.each do |klass|
        copy_file "#{klass}.rb", "lib/templates/#{klass}.rb"
      end

      array_views.each do |view|
        copy_file "views/#{view}.html.erb", "lib/templates/views/#{view}.html.erb"
      end

      copy_file "layouts/admin.html.erb", "app/views/layouts/admin.html.erb"
      copy_file "stylesheets/ie.css", "app/assets/stylesheets/ie.css"
      copy_file "stylesheets/layout.css", "app/assets/stylesheets/layout.css"
      copy_file "stylesheets/bootstrap-responsive.css", "app/assets/stylesheets/bootstrap-responsive.css"
      copy_file "stylesheets/bootstrap.css.erb", "app/assets/stylesheets/bootstrap.css.erb"
      copy_file "stylesheets/docs.css.erb", "app/assets/stylesheets/docs.css.erb"

      array_javascripts.each do |js|
        copy_file "javascripts/#{js}.js", "app/assets/javascripts/#{js}.js"
      end

      directory "images/icons", "app/assets/images/icons"
    end

    def inject_code_helper
      path = IO.readlines("config/routes.rb")
      content = File.open(File.expand_path("../templates/code_application_helper.rb", __FILE__), 'r') {|file| file.read}
      sentinel = /module ApplicationHelper/
      app = /::Application/
      engine = /::Engine/
      application = path.first.gsub(/::(.*)/, "").chomp.underscore

      if path.first =~ app
        inject_into_file "app/helpers/application_helper.rb", "\n#{content}\n", { after: sentinel, verbose: false }
      elsif path.first =~ engine
        inject_into_file "app/helpers/#{application}/application_helper.rb", "\n#{content}\n", { after: sentinel, verbose: false }
      end
    end

    def array_classes
      %w[controller helper model migration]
    end

    def array_views
      %w[edit _form index new show]
    end

    def array_javascripts
      %w[app bootstrap.min bootswatch html5 jquery-1.7.2.min jquery.easing.1.3 login]
    end

  end
end
