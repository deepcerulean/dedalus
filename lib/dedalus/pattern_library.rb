module Dedalus
  module PatternLibrary
    class LibrarySectionOrganism < Dedalus::Organism
      attr_accessor :title, :subtitle, :description, :color, :items

      def show
        [
          Elements::Heading.new(text: title),
          Elements::Heading.new(text: subtitle, scale: 0.9),
          Elements::Paragraph.new(text: description)
        ] + library_items
      end

      def library_items
        items.map do |name:, kind:, description:, item_class_name:, item_data:|
          LibraryItemMolecule.new( 
                                  name: name,
                                  kind: kind,
                                  description: description,
                                  item_data: item_data,
                                  item_class_name: item_class_name
                                 )
        end
      end

      def background_color
        Palette.decode_color("light#{color}")
      end
    end
  end
end
