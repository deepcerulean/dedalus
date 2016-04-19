module Dedalus
  module PatternLibrary
    class LibraryView < Metacosm::View
      attr_accessor :library_name, :library_section_tabs
      belongs_to :application_view
    end

    class ApplicationView < Joyce::ApplicationView
      attr_reader :id
      has_one :library_view

      def initialize(app)
        super(app)
        Dedalus.activate!(self)
      end

      def render
        composer.render!( app_screen, mouse_position: mouse_position, dimensions: [ window.width, window.height ])

        cursor.position = mouse_position
        cursor.render
      end

      def app_screen
        app_template.to_screen(
          mouse_position: mouse_position,
          library_sections: [welcome_tab] + library_view.library_section_tabs
        )
      end

      def welcome_tab
        { name: "Welcome", icon: :house, description: "About Dedalus" }
      end

      private
      def app_template
        @app_template ||= ApplicationTemplate.new
      end

      def cursor
        @cursor ||= Elements::Icon.for :arrow_cursor
      end

      def composer
        @composer ||= Dedalus::ApplicationViewComposer.new
      end
    end
  end
end
