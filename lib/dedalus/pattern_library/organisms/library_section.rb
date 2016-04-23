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
        items.map do |name:,  description:, item_class_name:, item_data:|
          LibraryItemMolecule.new(
                                  name: name,
                                  # kind: kind,
                                  description: description,
                                  item_data: item_data,
                                  item_class_name: item_class_name,
                                  color: background_color.darken
                                 )
        end
      end

      def padding
        @padding ||= 40
      end

      def background_color
        Palette.decode_color(color).lighten
      end

      def self.description
        "A section of a library"
      end

      def self.example_data
        { 
          title: "Hello",
          subtitle: "world",
          description: "Welcome to this section",
          color: "darkblue",
          padding: 0,
          items: [
            # {
            #   name: "Fake item",
            #   description: "Fake item description",
            #   item_class_name: "Dedalus::Elements::Text",
            #   item_data: { text: "Hello" }
            # }
          ]
        }
      end
    end
  end
end
