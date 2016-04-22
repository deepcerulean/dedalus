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

        screen = composer.hover_molecule(screen, [window.width, window.height], mouse_position: mouse_position)
        composer.render!(screen, [ window.width, window.height ])

        cursor.position = mouse_position
        cursor.render
      end

      def click
        p [ :app_view_click ]
        # TODO cascade click through whole strucutre? need to even click atoms maybe...?
        composer.click_molecule(app_screen, [window.width, window.height], mouse_position: mouse_position)
      end

      def app_screen
        ApplicationTemplate.new.to_screen(
          library_sections: [welcome_tab] + library_view.library_section_tabs,
          current_section_name: current_section
        )
      end

      def welcome_tab
        { name: "Welcome", icon: :house, description: "About Dedalus", background_color: 0x70a0c0d0 }
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
