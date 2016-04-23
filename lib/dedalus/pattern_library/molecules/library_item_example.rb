module Dedalus
  module PatternLibrary
    class LibraryItemExample < Dedalus::Molecule
      attr_accessor :item_class
      attr_accessor :item_data
      attr_accessor :color

      def show
        [
          Elements::Paragraph.new(text: "EXAMPLE", scale: 0.5, height_percent: 0.05, background_color: color.darken.darken),
          item
        ]
      end

      def item
        item_class.new(item_data) #.merge(height_percent: 0.99))
      end

      def width_percent
        0.6
      end

      def background_color
        color.darken
      end

      def self.description
        "an example of a patten"
      end

      def self.example_data
        { item_class: Dedalus::Elements::Heading, item_data: { text: "Hi!" }, color: Palette.red }
      end
    end
  end
end
