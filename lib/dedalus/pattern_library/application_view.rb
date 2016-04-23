module Dedalus
  module PatternLibrary
    class ApplicationView < Dedalus::ApplicationView
      attr_accessor :library_view

      def render
        compose(app_screen)
      end

      def click
        p [ :app_view_click ]
        composer.click_molecule(app_screen, [window.width, window.height], mouse_position: mouse_position)
      end

      def app_screen
        ApplicationScreen.new(app_template).hydrate(
          library_section_tabs: library_view.library_section_tabs,
          current_section_name: current_section,
          library_sections: library_view.library_sections
        )
      end

      def app_template
        ApplicationTemplate.new
      end

      def current_section
        @current_section_name ||= "Welcome"
      end

      def route_to(section_name)
        @current_section_name = section_name
      end
    end
  end
end
