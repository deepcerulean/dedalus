module Dedalus
  module PatternLibrary
    class LibraryItemExample < Dedalus::Molecule
      attr_accessor :item_class
      attr_accessor :item_data
      attr_accessor :color

      def show
        [
          Elements::Paragraph.new(text: "EXAMPLE", scale: 0.5, height_percent: 0.05, background_color: color.darken.darken),
          item,
          Elements::Paragraph.new(text: item_data, scale: 0.7, background_color: Palette.decode_color('darkgray'), padding: 10)
        ]
      end

      def item
        item_class.new(item_data)
      end

      def width_percent
        0.6
      end

      def background_color
        color.darken
      end

      def self.description
        "an example of a pattern"
      end

      def self.example_data
        { item_class: Dedalus::Elements::Heading, item_data: { text: "Hi!" }, color: Palette.red }
      end
    end
  end
end
