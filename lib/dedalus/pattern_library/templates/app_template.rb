module Dedalus
  module PatternLibrary
    class ApplicationTemplate < Dedalus::Template
      def layout(library_section_tabs:, current_section_name:, library_sections:)
        [
          app_header,
          [ 
            sidebar(library_section_tabs, current_section_name), library_page(library_sections, current_section_name) 
          ],
          app_footer
        ]
      end

      private
      def library_page(sections, name)
        current_section = sections.detect { |section| section[:title] == name }
        LibrarySectionOrganism.new(current_section)
      end

      def app_header
        ApplicationHeader.new(
          title: 'Dedalus',
          subtitle: 'A Visual Pattern Library for Joyce',
          height_percent: 0.15,
          background_color: Palette.blue
        )
      end

      def app_footer
        ApplicationFooter.new(
          joyce_version: Joyce::VERSION,
          dedalus_version: Dedalus::VERSION,
          company: "Deep Cerulean Simulations and Games",
          copyright: "2015-#{Time.now.year}",
          height_percent: 0.10,
          background_color: Palette.decode_color('darkgreen')
        )
      end

      def sidebar(sections, current_section_name)
        @sidebar ||= ApplicationSidebar.new(
          library_section_tab_molecules: section_tabs(sections, current_section_name),
          width_percent: 0.2,
          background_color: Palette.decode_color('darkgray')
        )
      end

      def section_tabs(sections, current_section_name)
        sections.map do |attrs|
          highlight = attrs[:name] == current_section_name
          LibrarySectionTab.new(attrs.merge(highlight: highlight))
        end
      end
    end
  end
end
