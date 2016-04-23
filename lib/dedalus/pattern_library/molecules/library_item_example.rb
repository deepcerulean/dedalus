module Dedalus
  module PatternLibrary
    class LibraryItemExample < Dedalus::Molecule
      attr_accessor :item_class
      attr_accessor :item_data

      def show
        [
          Elements::Paragraph.new(text: "EXAMPLE", scale: 0.5),
          item
          # Elements::Code.new(text: item_data, scale: 0.45)
        ]
      end

      def item
        item_class.new(item_data)
      end

      def padding
        10.0
      end

      def color
        'darkgray'
      end
    end
  end
end
