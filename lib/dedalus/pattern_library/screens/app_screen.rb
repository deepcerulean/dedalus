module Dedalus
  module PatternLibrary
    class ApplicationScreen < Dedalus::Screen
      def initialize(template)
        @template = template
      end

      def padding
        20
      end

      def show
        @template.show
      end

      def hydrate(library_section_tabs:, current_entry_name:, library_sections:, library_items:)
        @template.library_section_tabs = library_section_tabs
        @template.current_entry_name = current_entry_name
        @template.library_sections = library_sections
        @template.library_items = library_items
        self
      end

      def background_color
        Palette.decode_color 'darkgray'
      end
    end
  end
end
