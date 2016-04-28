module Dedalus
  module PatternLibrary
    class ApplicationTemplate < Dedalus::Template
      attr_accessor :library_name, :library_section_tabs, :current_entry_name
      attr_accessor :library_sections, :library_items

      def show
        layout do
          library_page
        end
      end

      def layout
        [
          app_header,
          [ sidebar, yield ]
          # app_footer
        ]
      end

      def self.example_data
        {
          library_name: "Ipsum Librarum",
          library_sections: [ {
            title: "Welcome",
            subtitle: "Fake section",
            color: 'blue',
            show_table: false,
            items: []
          } ], #, LibraryEntry.example_data ],
          library_section_tabs: [ LibrarySectionTab.example_data ],
          library_items: [], # LibraryItemExample.example_data ],
          current_entry_name: 'Welcome'
        }
      end

      def self.description
        "pattern library template"
      end

      private
      def library_page
        if current_section
          LibraryEntry.new(current_section)
        elsif current_item
          LibraryEntry.from_item(current_item)
        else
          Elements::Paragraph.new(text: "no page selected")
        end
      end

      def current_section
        library_sections.detect { |section| section[:title] == current_entry_name }
      end

      def current_item
        library_items.detect { |item| item[:name] == current_entry_name }
      end

      def app_header
        ApplicationHeader.new(
          title: library_name,
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

      def sidebar
        ApplicationSidebar.new(
          library_section_tab_molecules: section_tabs,
          width_percent: 0.2,
          background_color: Palette.decode_color('darkgray')
        )
      end

      def section_tabs
        tab_list = library_section_tabs.map do |attrs|
          highlight = attrs[:name] == current_entry_name
          LibrarySectionTab.new(attrs.merge(highlight: highlight))
        end
        # p [ tab_list: tab_list ]
        tab_list
      end
    end
  end
end
