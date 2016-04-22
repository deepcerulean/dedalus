module Dedalus
  module PatternLibrary
    class Application < Joyce::Application
      viewed_with ApplicationView
      include Models

      def click
        p [ :app_click ]
        view.click
      end

      def setup
        library = Library.create(name: "Dedalus Pattern Library")

        atom_section = library.create_library_section(
          name: "Atoms",
          icon: :atom,
          color: 'red',
          about: "Components that can't be split further"
        )

        atom_section.create_library_item(
          name: "Paragraph",
          kind: "Atom",
          description: "A block of text"
        )

        library.create_library_section(
          name: "Molecules",
          icon: :molecule,
          color: 'yellow',
          about: "Simple compounds of a few atoms"
        )

        library.create_library_section({
          name: "Organisms",
          icon: :paramecium,
          color: 'green',
          about: "Highly-complex assemblages of molecules"
        })

        library.create_library_section({
          name: "Templates",
          icon: :hive,
          color: 'blue',
          about: "Assembled screens with placeholders"})

        # just manually create a view from models for now...

        view.create_library_view(
          library_name: library.name,

          library_sections: library.library_sections.map do |section|
            {
              title: section.name,
              subtitle: section.about,
              color: section.color
            }
          end,

          library_section_tabs: library.library_sections.map do |section|
            { name: section.name,
              icon: section.icon,
              description: section.about,
              section_color: section.color
            }
          end
        )
      end
    end
  end
end
