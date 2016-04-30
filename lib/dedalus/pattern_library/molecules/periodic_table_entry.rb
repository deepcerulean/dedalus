module Dedalus
  module PatternLibrary
    class PeriodicTableEntry < Dedalus::Molecule
      attr_accessor :element_name
      attr_accessor :kind
      attr_accessor :color
      attr_accessor :scale

      def show
        [
          HugeText.new(text: abbreviation, scale: scale),
          LargeText.new(text: element_name, scale: scale),
          TinyText.new(text: kind, scale: scale)
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
        30 * scale
      end

      def width
        260 * scale
      end

      def height
        300 * scale
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
          element_abbreviation: "Ht",
          element_name: "Huge Text"
        }
      end
    end
  end
end
