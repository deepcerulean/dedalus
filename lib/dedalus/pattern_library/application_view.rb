module Dedalus
  module PatternLibrary
    class ApplicationView < Joyce::ApplicationView
      def initialize(app)
        super(app)
        Dedalus.activate!(self)
      end

      def render
        composer.render!(
          app_screen,
          dimensions: [ window.width, window.height ]
        )
        cursor.update(position: mouse_position)
        cursor.render
      end

      def app_screen
        app_template.to_screen(base_data.merge(library_data))
      end

      def base_data
        {
          viewing_section: :welcome,
          mouse_position: mouse_position
        }
      end

      def library_data
        {
          library_sections: [
            {name: "Welcome",
             icon: :atom,
             description: "About Dedalus" },

            {name: "Atoms",
            icon: :atom,
            description: "Minimal elements which can't be split further",
            color: 0x70a0c0c0},

            {name: "Molecules",
             icon: :molecule,
             description: "Simple compounds of a few atoms"},

            {name: "Organisms",
             icon: :paramecium,
             description: "Highly-complex assemblages of molecules"},

            {name: "Templates",
             icon: :hive,
             description: "Assembled app screens with placeholders"}
          ]
        }
      end

      private
      def app_template
        @app_template ||= ApplicationTemplate.create
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
