module Dedalus
  module PatternLibrary
    module Models
      class LibraryItem < Metacosm::Model
        attr_accessor :name, :kind, :description
        belongs_to :library_section
      end

      class LibrarySection < Metacosm::Model
        attr_accessor :name, :about, :description, :icon
        belongs_to :library
        has_many :library_items
      end

      class Library < Metacosm::Model
        attr_accessor :name
        has_many :library_sections
      end
    end

    class ApplicationHeader < Dedalus::Organism
      attr_accessor :title, :subtitle

      def show
        [ heading, subheading ]
      end

      private
      def heading
        @heading ||= Elements::Heading.new(text: title)
      end

      def subheading
        @subheading ||= Elements::Heading.new(text: subtitle, scale: 0.75)
      end
    end

    class ApplicationSidebar < Dedalus::Organism
      attr_accessor :library_section_tab_molecules

      def show
        self.library_section_tab_molecules
      end
    end

    class ApplicationFooter < Dedalus::Organism
      attr_accessor :joyce_version, :dedalus_version, :company, :copyright

      def show
        [ footer_message ]
      end

      private
      def footer_message
        @footer_message ||=  Elements::Paragraph.new(text: assemble_text, scale: 0.5)
      end

      def assemble_text
        "Powered by Dedalus v#{dedalus_version} and Joyce v#{joyce_version}. Copyright #{company} #{copyright}. All rights reserved."
      end
    end

    class LibrarySectionTabMolecule < Dedalus::Molecule
      attr_accessor :icon, :name, :description, :color, :scale

      def show
        [[
          icon_element, [ title_element,
                          description_element ]
        ]]
      end

      def hover
        p [ :hovering_on, section: name ]
        @scale = 0.2
        # self.background = 0xf0f0f0f0
      end

      def scale
        @scale ||= 0.1
      end

      def height_percent
        0.15
      end

      def icon_element
        Elements::Icon.for(icon, padding: 30)
      end

      def title_element
        Elements::Heading.new(text: name, scale: 0.6 + scale)
      end

      def description_element
        Elements::Paragraph.new(text: description, scale: 0.5)
      end
    end

    class ApplicationTemplate < Dedalus::Template
      def layout(library_sections:)
        [
          app_header,
          [ sidebar(library_sections), yield ],
          app_footer
        ]
      end

      def to_screen(library_sections:, mouse_position:)
        screen = ApplicationScreen.new(self)
        screen.hydrate(library_sections: library_sections)
        screen
      end

      private
      def app_header
        ApplicationHeader.new(
          title: 'Dedalus',
          subtitle: 'A Visual Pattern Library for Joyce',
          height_percent: 0.15
        )
      end

      def app_footer
        ApplicationFooter.new(
          joyce_version: Joyce::VERSION,
          dedalus_version: Dedalus::VERSION,
          company: "Deep Cerulean Simulations and Games",
          copyright: "2015-#{Time.now.year}",
          height_percent: 0.10
        )
      end

      def sidebar(sections)
        section_tabs = sections.map do |attrs|
          LibrarySectionTabMolecule.new(attrs)
        end

        ApplicationSidebar.new(
          library_section_tab_molecules: section_tabs,
          width_percent: 0.45
        )
      end
    end

    class ApplicationScreen < Dedalus::Screen
      def initialize(template)
        @template = template
      end

      def show
        @template.layout(library_sections: @library_sections) do
          current_section
        end
      end

      def hydrate(library_sections:)
        @library_sections = library_sections
      end

      def current_section
        @current_section ||= WelcomeSectionOrganism.new
      end
    end

    # actual content of the lib section pane
    class LibrarySectionOrganism < Dedalus::Organism
      # ...
    end

    class WelcomeSectionOrganism < LibrarySectionOrganism
      def show
        [welcome_message] + welcome_discussion
      end

      def welcome_message
        Elements::Heading.new(text: "Welcome to our Pattern Library!")
      end

      def welcome_discussion
        [
          Elements::Paragraph.new(text: "Dedalus is a visual pattern library for 2-d games..."),
          Elements::Paragraph.new(text: "Dedalus follows atomic design principles...")
        ]
      end
    end
  end
end
