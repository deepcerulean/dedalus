module Dedalus
  module PatternLibrary
    class ApplicationView < Dedalus::ApplicationView
      attr_accessor :library_view

      def app_screen
        ApplicationScreen.new(app_template).hydrate(
          mouse_position: mouse_position,
          library_section_tabs: library_view.library_section_tabs,
          current_entry_name: current_entry_name,
          library_sections: library_view.library_sections,
          library_items: library_view.library_items
        )
      end

      def app_template
        ApplicationTemplate.new
      end

      def current_entry_name
        @current_entry_name ||= "Welcome"
      end

      def route_to(section_name)
        @current_entry_name = section_name
      end
    end
  end
end
