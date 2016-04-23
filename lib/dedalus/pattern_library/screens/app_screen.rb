module Dedalus
  module PatternLibrary
    class ApplicationScreen < Dedalus::Screen
      attr_reader :library_section_tabs, :current_section_name, :library_sections

      def initialize(template)
        @template = template
      end

      def padding
        0.2
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
        0x40a0a0a0
      end
    end
  end
end
