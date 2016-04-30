module Dedalus
  module PatternLibrary
    class LibraryEntry < Dedalus::Organism
      attr_accessor :title, :subtitle, :description, :color, :items, :item, :show_table

      def self.from_item(item)
        new(title: item[:name], subtitle: item[:description], item: item)
      end

      def show
        [
          HugeText.new(text: title),
          LargeText.new(text: subtitle),
          TinyText.new(text: description)
        ] + [ library_items ]
      end

      def library_items
        if items
          if show_table
            PeriodicTable.new(elements: items)
          else # items
            items.map do |name:, description:, item_class_name:, item_data:, kind:, color:|
              PeriodicTableEntry.new(
                element_name: name,
                color: color,
                kind: kind)
            end
          end
        elsif item
          LibraryItemExample.new(item)
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
        elsif item && item[:color]
          Palette.decode_color(item[:color])
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
          items: [ LibraryItemExample.example_data ]
        }
      end
    end
  end
end
