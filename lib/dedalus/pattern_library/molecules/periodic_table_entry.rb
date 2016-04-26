module Dedalus
  module PatternLibrary
    class PeriodicTableEntry < Dedalus::Molecule
      attr_accessor :element_name
      attr_accessor :kind
      attr_accessor :color
      attr_accessor :scale

      def show
        [
          Elements::Heading.new(text: abbreviation, scale: 6.0 * scale),
          Elements::Paragraph.new(text: element_name, scale: scale),
          Elements::Paragraph.new(text: kind, scale: 0.6 * scale)
        ]
      end

      def scale
        @scale ||= 1.0
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
        15 * scale
      end

      def padding
        20 * scale
      end

      def width
        230 * scale
      end

      def height
        250 * scale
      end

      def background_color
        if color
          c = Palette.decode_color(color) if color.is_a?(String)
          c.darken
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
