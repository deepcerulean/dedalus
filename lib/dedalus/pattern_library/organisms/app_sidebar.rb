module Dedalus
  module PatternLibrary
    class ApplicationSidebar < Dedalus::Organism
      attr_accessor :library_section_tabs, :current_entry #_molecules

      def show
        library_section_tab_rows
      end

      def library_section_tab_rows
        @tab_rows ||= self.library_section_tabs.map do |tab_data| #_molecules
          tab_data[:highlight] = tab_data[:name] == current_entry
          LibrarySectionTab.new(tab_data)
        end
      end

      def padding
        0
      end

      def self.description
        "A sidebar for an application"
      end

      def self.example_data
        {
          library_section_tabs: [
            LibrarySectionTab.example_data,
            LibrarySectionTab.example_data,
            LibrarySectionTab.example_data
          ]
        }
      end
    end
  end
end
