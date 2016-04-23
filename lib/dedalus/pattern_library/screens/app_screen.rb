module Dedalus
  module PatternLibrary
    class ApplicationScreen < Dedalus::Screen
      attr_reader :library_section_tabs, :current_section_name, :library_sections

      def initialize(template)
        @template = template
      end

      def padding
        40.2
      end

      def show
        @template.layout(
          library_section_tabs: @library_section_tabs,
          current_section_name: @current_section_name,
          library_sections: @library_sections
        )
      end

      def hydrate(library_section_tabs:, current_section_name:, library_sections:)
        @library_section_tabs = library_section_tabs
        @current_section_name = current_section_name
        @library_sections = library_sections
        self
      end

      def background_color
        Palette.decode_color 'darkgray'
      end
    end
  end
end
