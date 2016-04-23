module Dedalus
  module PatternLibrary
    class ApplicationView < Joyce::ApplicationView
      attr_reader :id
      has_one :library_view

      def initialize(app)
        super(app)
        Dedalus.activate!(self)
      end

      def render
        screen = app_screen

        screen = composer.hover_molecule(screen, [window.width, window.height], mouse_position: adjusted_mouse_position)
        composer.render!(screen, [ window.width, window.height ])

        cursor.position = adjusted_mouse_position
        cursor.render
      end

      def click
        p [ :app_view_click ]
        # TODO cascade click through whole strucutre? need to even click atoms maybe...?
        composer.click_molecule(app_screen, [window.width, window.height], mouse_position: adjusted_mouse_position)
      end

      def adjusted_mouse_position
        if @application.window.fullscreen?
          x0,y0 = *mouse_position
          [ x0 * 2, y0 * 2 ]
        else
          mouse_position
        end
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

      private
      def cursor
        @cursor ||= Elements::Icon.for :arrow_cursor
      end

      def composer
        @composer ||= Dedalus::ApplicationViewComposer.new
      end
    end
  end
end
