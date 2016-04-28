module Dedalus
  module PatternLibrary
    class LibraryItemExample < Dedalus::Molecule
      attr_accessor :name
      attr_accessor :item_class_name
      attr_accessor :item_data
      attr_accessor :kind
      attr_accessor :color

      def show
        [
          Elements::Paragraph.new(text: "EXAMPLE", scale: 0.5, height_percent: 0.05, background_color: background_color.darken),
          item,
          Elements::Paragraph.new(text: item_data, scale: 0.7, background_color: Palette.decode_color('darkgray'), padding: 10)
        ]
      end

      def item
        item_class_name.constantize.new(item_data)
      end

      def width_percent
        0.6
      end

      def background_color
        if color
          Palette.decode_color(color).darken
        else
          Palette.gray
        end
      end

      def self.description
        "an example of a pattern"
      end

      def self.example_data
        {
          name: "Huge Text",
          description: "(fake library item molecule)",
          item_class_name: 'Dedalus::PatternLibrary::HugeText',
          item_data: { text: "Hi there!" },
          color: 'red', #Palette.red,
          kind: 'Atom'
        }
      end
    end
  end
end
