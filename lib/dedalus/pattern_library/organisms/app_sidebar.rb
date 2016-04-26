module Dedalus
  module PatternLibrary
    class ApplicationSidebar < Dedalus::Organism
      attr_accessor :library_section_tab_molecules

      def show
        self.library_section_tab_molecules
      end

      def padding
        0
      end

      def self.description
        "A sidebar for an application"
      end

      def self.example_data
        {
          library_section_tab_molecules: [
            LibrarySectionTab.new(LibrarySectionTab.example_data),
            LibrarySectionTab.new(LibrarySectionTab.example_data),
            LibrarySectionTab.new(LibrarySectionTab.example_data)
          ]
        }
      end
    end
  end
end
