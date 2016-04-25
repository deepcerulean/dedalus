module Dedalus
  module PatternLibrary
    class PeriodicTableEntry < Dedalus::Molecule
      attr_accessor :element_name
      attr_accessor :color

      def show
        [
          Elements::Heading.new(text: abbreviation, scale: 6.0),
          Elements::Paragraph.new(text: element_name)
        ]
      end

      def abbreviation
        if element_name.match(/ /) #split(" ").count > 0
          element_name.split(" ").map(&:first).join.capitalize
        else
          element_name.slice(0,2).capitalize
        end
      end

      def click
        view.route_to(element_name)
      end

      def margin
        15
      end

      def padding
        20
      end

      def width
        180
      end

      def height
        200
      end

      def background_color
        if color
          color.darken
        else
          Palette.gray
        end
      end

      def self.description
        "a high-level view of an element"
      end

      def self.example_data
        {
          element_abbreviation: "Pa",
          element_name: "Paragraph"
        }
      end
    end
  end
end
