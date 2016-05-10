module Dedalus
  module PatternLibrary
    class PeriodicTable < Dedalus::Molecule
      attr_accessor :elements

      def show
        self.element_groups.map do |_, grouped_elements|
          grouped_elements.map do |name:, color:, kind:, **|
            PeriodicTableEntry.new(
              element_name: name,
              color: color,
              kind: kind,
              scale: 0.35
            )
          end
        end
      end

      def element_groups
        elements.group_by { |elem| elem[:kind] }
      end

      def self.description
        "A collection of elements"
      end

      def self.example_data
        { elements: Array.new(4) { LibraryItemExample.example_data } }
      end
    end
  end
end
