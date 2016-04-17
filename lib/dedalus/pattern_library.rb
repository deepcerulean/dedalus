module Dedalus
  module PatternLibrary
    class ApplicationView < Joyce::ApplicationView
      def render
        composer.render!(welcome_screen)

        cursor = Elements::Icon.for(:arrow_cursor)
        cursor.update(position: mouse_position)
        cursor.render(self)
      end

      private
      def welcome_screen
        @welcome_screen ||= WelcomeScreen.create
      end

      def composer
        @composer ||= Dedalus::ApplicationViewComposer.new(self)
      end
    end

    class Application < Joyce::Application
      viewed_with ApplicationView
    end

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

      def height_percent
        0.1
      end

      private
      def footer_message
        @footer_message ||=  Elements::Paragraph.create(text: assemble_text)
      end

      def assemble_text
        "Powered by Dedalus v#{dedalus_version} and Joyce v#{joyce_version}. Copyright #{company} #{copyright}, all rights reserved."
      end
    end

    class LibrarySection < Dedalus::Molecule
      belongs_to :application_sidebar
      attr_accessor :icon, :name, :description

      def show
        [[
          icon_element, [ title_element,
                          description_element ]
        ]]
      end

      def height_percent
        0.2
      end

      private
      def icon_element
        @icon_element ||= Elements::Icon.for(icon)
      end

      def title_element
        @title ||= Elements::Heading.create(text: name)
      end

      def description_element
        @notes ||= Elements::Paragraph.create(text: description)
      end
    end

    class ApplicationScreen < Dedalus::Template
      def layout
        [
          app_header, 
          [ sidebar, yield ],
          app_footer
        ]
      end

      private
      def app_header
        @app_header ||= ApplicationHeader.create(
          title: 'Dedalus',
          subtitle: 'A Visual Pattern Library for Joyce',
          height_percent: 0.10
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

      def sidebar
        @sidebar ||= ApplicationSidebar.create(
          library_sections: [
            # LibrarySection.create(name: "Home"),
            LibrarySection.create(name: "Atoms", icon: :atom, description: "Minimal elements which can't be split further"),
            LibrarySection.create(name: "Molecules", icon: :molecule, description: "Simple compounds of a few atoms"),
            LibrarySection.create(name: "Organisms", icon: :paramecium, description: "Highly-complex assemblages of molecules"),
            LibrarySection.create(name: "Templates", icon: :hive, description: "Composed app screens with placeholder data"),
            # LibrarySection.create(name: "Screens")
          ],
          width_percent: 0.30
        )
      end
    end

    class WelcomeScreen < ApplicationScreen
      def show
        layout { welcome_message }
      end

      def welcome_message
        @welcome_message ||= Elements::Heading.create(text: "Welcome to our Pattern Library!")
      end
    end
  end
end
