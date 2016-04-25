module Dedalus
  module PatternLibrary
    class LibraryEntry < Dedalus::Organism
      attr_accessor :title, :subtitle, :description, :color, :items, :item

      def self.from_item(item)
        new(title: item[:name], subtitle: item[:description], item: item)
      end

      def show
        [
          Elements::Heading.new(text: title),
          Elements::Heading.new(text: subtitle, scale: 0.9),
          Elements::Paragraph.new(text: description)
        ] + [ library_items ]
      end

      def library_items
        if items
          items.map do |name:,  description:, item_class_name:, item_data:|
            PeriodicTableEntry.new(
              element_name: name,
              color: background_color
            )
          end
        elsif item
          LibraryItemMolecule.new(item.merge(color: background_color))
          #   name: name,
          #   # kind: kind,
          #   description: description,
          #   item_data: item_data,
          #   item_class_name: item_class_name,
          #   color: background_color.darken
          # )
          #item
        else
          []
        end
      end

      def padding
        @padding ||= 40
      end

      def background_color
        if color
          Palette.decode_color(color).lighten
        else
          Palette.gray
        end
      end

      def self.description
        "An entry in a library"
      end

      def self.example_data
        {
          title: "Welcome",
          subtitle: "world",
          description: "Welcome to this section",
          color: "darkblue",
          # padding: 0,
          items: [ LibraryItemMolecule.example_data ]
        }
      end
    end
  end
end
