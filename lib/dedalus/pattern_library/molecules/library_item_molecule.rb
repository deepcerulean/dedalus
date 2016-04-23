module Dedalus
  module PatternLibrary
    class LibraryItemMolecule < Dedalus::Molecule
      attr_accessor :name, :kind, :description, :item_data, :item_class_name

      def show
        [[
          [Elements::Heading.new(text: name, scale: 2.0),
          Elements::Paragraph.new(text: description)],

          example
        ]]
      end

      def example
        LibraryItemExample.new(item_class: item_class_name.constantize, item_data: item_data)
      end

      def padding
        10
      end

      def background_color
        Palette.decode_color 'darkred'
      end

      def height
        120
      end
    end
  end
end
