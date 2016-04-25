module Dedalus
  module PatternLibrary
    class LibrarySectionTab < Dedalus::Molecule
      attr_accessor :icon, :name, :description, :scale, :highlight, :section_color

      def show
        [[
          icon_element, [ title_element,
                          description_element ]
        ]]
      end

      def hover
        p [ :hovering_on, section: name ]
        @scale = 0.2
      end

      def background_color
        bg = Palette.decode_color(section_color)
        self.highlight ? bg.lighten : bg
      end

      def click
        view.route_to(name)
      end

      def scale
        @scale ||= 0.0
      end

      def height
        @height ||= 80
      end

      def icon_element
        Elements::Icon.for(icon, padding: 16)
      end

      def title_element
        Elements::Heading.new(text: name, scale: 1.8 + scale)
      end

      def description_element
        Elements::Paragraph.new(text: description)
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
