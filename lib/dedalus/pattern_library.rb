module Dedalus
  module PatternLibrary
    class ApplicationHeader < Dedalus::Organism
      attr_accessor :title, :subtitle

      def show
        [ heading, subheading ]
      end

      private
      def heading
        @heading ||= Elements::Heading.create(text: title)
      end

      def subheading
        @subheading ||= Elements::Heading.create(text: subtitle, scale: 0.75)
      end
    end

    class ApplicationSidebar < Dedalus::Organism
      has_many :library_sections

      def show
        self.library_sections.all
      end
    end

    class ApplicationFooter < Dedalus::Organism
      attr_accessor :joyce_version, :dedalus_version, :company, :copyright

      def show
        [ footer_message ]
      end

      private
      def footer_message
        @footer_message ||=  Elements::Paragraph.create(text: assemble_text, scale: 0.5)
      end

      def assemble_text
        "Powered by Dedalus v#{dedalus_version} and Joyce v#{joyce_version}. Copyright #{company} #{copyright}. All rights reserved."
      end
    end

    class LibrarySection < Dedalus::Molecule
      belongs_to :application_sidebar
      attr_accessor :icon, :name, :description, :color

      after_create do
        self.height_percent ||= 0.15
        self.icon_element.padding = 30.0
      end

      def show
        [[
          icon_element, [ title_element,
                          description_element ]
        ]]
      end

      def icon_element
        @icon_element ||= Elements::Icon.for(icon)
      end

      def title_element
        @title ||= Elements::Heading.create(text: name, scale: 1.8)
      end

      def description_element
        @notes ||= Elements::Paragraph.create(text: description, scale: 0.5)
      end
    end

    class ApplicationTemplate < Dedalus::Template
      def layout(sections:)
        [
          app_header,
          [ sidebar(sections), yield ],
          app_footer
        ]
      end

      def to_screen(data)
        screen = ApplicationScreen.new(self)
        screen.hydrate(data)
        screen
      end

      private
      def app_header
        @app_header ||= ApplicationHeader.create(
          title: 'Dedalus',
          subtitle: 'A Visual Pattern Library for Joyce',
          height_percent: 0.15
        )
      end

      def app_footer
        @app_footer ||= ApplicationFooter.create(
          joyce_version: Joyce::VERSION,
          dedalus_version: Dedalus::VERSION,
          company: "Deep Cerulean Simulations and Games",
          copyright: "2015-#{Time.now.year}",
          height_percent: 0.10
        )
      end

      def sidebar(sections)
        @lib_sections ||= sections.map do |attrs|
          LibrarySection.create(attrs)
        end

        @sidebar ||= ApplicationSidebar.create(
          library_sections: @lib_sections,
          # [
          #   atoms_library_section,
          #   LibrarySection.create(name: "Molecules", icon: :molecule,   description: "Simple compounds of a few atoms"),
          #   LibrarySection.create(name: "Organisms", icon: :paramecium, description: "Highly-complex assemblages of molecules"),
          #   LibrarySection.create(name: "Templates", icon: :hive,       description: "Assembled app screens with placeholders")
          # ],
          width_percent: 0.45
        )
      end

      def atoms_library_section
        @atom_section ||= LibrarySection.create(
          name: "Atoms",
          icon: :atom,
          description: "Minimal elements which can't be split further",
          color: 0x70a0c0c0
        )
      end
    end

    class ApplicationScreen < Dedalus::Screen
      def initialize(template)
        @template = template
      end

      def show
        @template.layout(sections: library_section_data) { welcome_message }
      end

      def hydrate(app_data)
        @app_data = app_data
      end

      def library_section_data
        @app_data[:library_sections]
      end

      def welcome_message
        @welcome_message ||= Elements::Heading.create(text: "Welcome to our Pattern Library!")
      end
    end
  end
end
