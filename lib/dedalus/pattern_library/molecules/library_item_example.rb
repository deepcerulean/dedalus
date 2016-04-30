module Dedalus
  module PatternLibrary
    class LibraryItemExample < Dedalus::Molecule
      attr_accessor :name
      attr_accessor :item_class_name
      attr_accessor :item_data
      attr_accessor :kind
      attr_accessor :color

      def show
        [[
          periodic_table_entry,
          example
        ]]
      end

      def periodic_table_entry
        PeriodicTableEntry.new(
          element_name: name,
          color: color,
          kind: kind,
          scale: 1.8
        )
      end

      def example
        [
          LargeText.new(text: "EXAMPLE", height_percent: 0.05, color: color),
          item,
          LargeText.new(text: "DATA", height_percent: 0.05, color: color),
          Code.new(text: item_data, background_color: Palette.decode_color('darkgray'), padding: 10)
        ]
      end

      def item
        item_class_name.constantize.new(item_data)
      end

      def width_percent
        0.6
      end

      def background_color
        nil
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
