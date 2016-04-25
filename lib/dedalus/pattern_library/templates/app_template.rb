module Dedalus
  module PatternLibrary
    class ApplicationTemplate < Dedalus::Template
      attr_accessor :library_section_tabs, :current_entry_name, :library_sections, :library_items

      def show
        layout do
          library_page(library_sections, library_items, current_entry_name)
        end
      end

      def layout
        [
          app_header,
          [
            sidebar(library_section_tabs, library_items, current_entry_name),
            yield
          ],
          app_footer
        ]
      end

      private
      def library_page(sections, items, entry_name)
        current_section = sections.detect { |section| section[:title] == entry_name } 
        if current_section
          LibraryEntry.new(current_section)
        else
          current_item = items.detect { |item| item[:name] == entry_name }
          LibraryEntry.from_item(current_item)
        end
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

      def sidebar(sections, items, current_section_name)
        ApplicationSidebar.new(
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
