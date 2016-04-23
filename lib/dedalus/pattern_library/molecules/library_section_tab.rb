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
        color = self.highlight ? "light#{@section_color}" : @section_color
        Palette.decode_color(color)
      end

      def click
        view.route_to(name)
      end

      def scale
        @scale ||= 0.0
      end

      def height
        @height ||= 100
      end

      def icon_element
        Elements::Icon.for(icon, padding: 20)
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
          section_color: 'lightyellow'
        }
      end
    end
  end
end
