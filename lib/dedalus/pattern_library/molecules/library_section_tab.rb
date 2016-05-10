module Dedalus
  module PatternLibrary
    class LibrarySectionTab < Dedalus::Molecule
      attr_accessor :icon, :name, :description, :scale, :highlight, :section_color

      def show
        Container.new(
          [[icon_element, [ title_element, description_element ]]],
          padding: 16,
          scale: scale
        )
      end

      def hover
        self.scale = 1.05
      end

      def background_color
        bg = Palette.decode_color(section_color)
        self.highlight ? bg.lighten : bg
      end

      def click
        view.route_to(name)
      end

      def scale
        @scale ||= 1.0
      end

      def height
        @height ||= 80
      end

      def icon_element
        Elements::Icon.for(icon, padding: 10)
      end

      def title_element
        Elements::Heading.new(text: name, scale: scale)
      end

      def description_element
        TinyText.new(text: description)
      end

      def self.description
        "navigational tab"
      end

      def self.example_data
        {
          icon: :house,
          name: "Welcome",
          description: "Hello world (links to Welcome)",
          highlight: false,
          section_color: 'gray'
        }
      end
    end
  end
end
