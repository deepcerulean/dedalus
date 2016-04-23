module Dedalus
  module PatternLibrary
    class LibrarySectionTabMolecule < Dedalus::Molecule
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

      def height_percent
        0.15
      end

      def icon_element
        Elements::Icon.for(icon, padding: 20)
      end

      def title_element
        Elements::Heading.new(text: name, scale: 0.6 + scale)
      end

      def description_element
        Elements::Paragraph.new(text: description, scale: 0.5)
      end
    end
  end
end
