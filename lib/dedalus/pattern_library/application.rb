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

        library.create_library_section(
          name: "Welcome",
          icon: :house,
          color: 'gray',
          about: "About the Dedalus library"
        )

        atom_section = library.create_library_section(
          name: "Atoms",
          icon: :atom,
          color: 'red',
          about: "Components that can't be split further"
        )

        atom_section.create_library_item(
          name: "Paragraph",
          kind: "Atom",
          description: "A block of text",
          item_class_name: "Dedalus::Elements::Paragraph",
          example_data: { text: "Hello World" }
        )

        atom_section.create_library_item(
          name: "Icon",
          kind: "Atom",
          description: "A recognizable symbol",
          item_class_name: "Dedalus::Elements::Icon",
          example_data: { name: "house" }
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
              color: section.color,
              items: section.library_items.map do |item|
                {
                  name: item.name,
                  kind: item.kind,
                  description: item.description,
                  item_class_name: item.item_class_name,
                  item_data: item.example_data
                }
              end
            }
          end,

          library_section_tabs: library.library_sections.map do |section|
            { 
              name: section.name,
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
