module Dedalus
  module PatternLibrary
    class ApplicationSidebar < Dedalus::Organism
      attr_accessor :library_section_tab_molecules

      def show
        self.library_section_tab_molecules
      end
    end
  end
end
