module Dedalus
  module PatternLibrary
    class ApplicationScreen < Dedalus::Screen
      def initialize(template)
        @template = template
      end

      def show
        @template.show
      end

      def hydrate(library_section_tabs:, current_entry_name:, library_sections:, library_items:)
        @template.library_name = "Dedalus Pattern Library"
        @template.library_section_tabs = library_section_tabs
        @template.library_sections = library_sections
        @template.library_items = library_items
        @template.current_entry_name = current_entry_name
        self
      end
    end
  end
end
