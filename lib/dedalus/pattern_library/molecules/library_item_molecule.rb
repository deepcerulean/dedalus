module Dedalus
  module PatternLibrary
    class LibraryItemMolecule < Dedalus::Molecule
      attr_accessor :name, :kind, :description, :item_data, :item_class_name, :color

      def show
        [[
          [
            Elements::Heading.new(text: name, scale: 2.0),
            Elements::Paragraph.new(text: description)
          ],

          example
        ]]
      end

      def example
        LibraryItemExample.new(item_class: item_class_name.constantize, item_data: item_data, color: background_color)
      end

      def margin
        10
      end

      def background_color
        Palette.decode_color(color).darken
      end

      # def height
      #   160
      # end

      def self.description
        "an item in a pattern library"
      end

      def self.example_data
        { name: "Fake Entry", kind: "Fake", description: "nothing", item_data: { text: "hello world" }, item_class_name: "Dedalus::Elements::Paragraph", color: 'yellow' }
      end
    end
  end
end
