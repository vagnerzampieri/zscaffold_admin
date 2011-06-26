module ScaffoldAdmin
  class InstallGenerator < Rails::Generators::Base
    desc 'Copy files for configuration ZScaffold Admin'
    
    def self.source_root
      @_install_source_root ||= File.expand_path("../templates", __FILE__)
    end
    
    def copy_files
      array_classes.each do |klass|
        copy_file "#{klass}.rb", "lib/templates/#{klass}.rb"
      end
      
      array_views.each do |view|
        copy_file "views/#{view}.html.erb", "lib/templates/views/#{view}.html.erb"  
      end
      
      copy_file "shared/_menu.html.erb", "app/views/shared/_menu.html.erb"
      copy_file "layouts/admin.html.erb", "app/views/layouts/admin.html.erb"
      copy_file "stylesheets/ie.css", "app/assets/stylesheets/ie.css"
      copy_file "stylesheets/layout.css", "app/assets/stylesheets/layout.css"
      
      array_javascripts.each do |js|
        copy_file "javascripts/#{js}.js", "app/assets/javascripts/#{js}.js"        
      end     
      
      array_images.each do |images|
        copy_file "images/#{images}.png", "app/assets/images/#{images}.png"
      end
    end

    def inject_code_helper
      path = IO.readlines("#{Rails.root}/config/routes.rb")
      content = File.open(File.expand_path("../templates/code_application_helper.rb", __FILE__), 'r') {|file| file.read}
      sentinel = /module ApplicationHelper/
      app = /::Application/
      engine = /::Engine/
      application = path.first.gsub(/::(.*)/, "").gsub("\n", "").underscore
      
      if path.first =~ app
        inject_into_file "#{Rails.root}/app/helpers/application_helper.rb", "\n#{content}\n", { :after => sentinel, :verbose => false }
      elsif path.first =~ engine
        inject_into_file "#{Rails.root}/app/helpers/#{application}/application_helper.rb", "\n#{content}\n", { :after => sentinel, :verbose => false }
      end      
    end
      
    def array_classes
      %w[controller helper model migration]
    end
    
    def array_views
      %w[edit _form index new show]
    end
    
    def array_javascripts
      %w[hideshow jquery.equalHeight jquery.tablesorter.min jquery-1.5.2.min]
    end
    
    def array_images
      %w[breadcrumb_divider btn_submit btn_submit_2 btn_view_site header_bg header_shadow icn_add_user icn_alert_error icn_alert_info icn_alert_success icn_alert_warning icn_audio icn_categories icn_edit icn_edit_article icn_folder icn_jump_back icn_logout icn_new_article icn_photo icn_profile icn_search icn_security icn_settings icn_tags icn_trash icn_user icn_video icn_view_users module_footer_bg post_message secondary_bar secondary_bar_shadow sidebar sidebar_divider sidebar_shadow table_sorter_header]
    end
    
  end
end
