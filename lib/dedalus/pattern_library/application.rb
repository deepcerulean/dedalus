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
        create_library
      end

      def find_descendants_of(klass)
        ObjectSpace.each_object(Class).select { |k| k < klass && find_descendants_of(k).count.zero? }
      end

      def create_library
        library = Library.create(name: "Dedalus Pattern Library")

        atom_section = library.create_library_section(
          name: "Atoms",
          icon: :atom,
          color: 'darkred',
          about: "Components that can't be split further"
        )

        atom_classes = find_descendants_of(Dedalus::Atom)
        atom_section.build_items_from_classes(atom_classes, kind: 'atom')

        molecules_section = library.create_library_section(
          name: "Molecules",
          icon: :molecule,
          color: 'yellow',
          about: "Simple compounds of a few atoms"
        )

        molecule_classes = find_descendants_of(Dedalus::Molecule)
        molecules_section.build_items_from_classes(molecule_classes, kind: 'molecule')

        organism_section = library.create_library_section({
          name: "Organisms",
          icon: :paramecium,
          color: 'green',
          about: "Highly-complex assemblages of molecules"
        })

        organism_classes = find_descendants_of(Dedalus::Organism)
        organism_section.build_items_from_classes(organism_classes, kind: 'organism')

        template_section = library.create_library_section({
          name: "Templates",
          icon: :hive,
          color: 'blue',
          about: "Assembled screens with placeholders"})

        template_section.create_library_item({
          name: "App Template",
          item_class_name: 'Dedalus::PatternLibrary::ApplicationTemplate',
          description: "ui library app",
          example_data: {
            library_name: "Ipsum Librarum",
            library_sections: [ LibraryEntry.example_data ],
            library_section_tabs: [ LibrarySectionTab.example_data ]
          }
        })

        # just manually create a view from models for now...
        library_data = serialize_library(library)
        library_view = LibraryView.create(library_data)
        view.library_view = library_view
      end

      def serialize_library(library)
        {
          library_name: library.name,

          library_sections: [welcome_section] + library.library_sections.map do |section|
            {
              title: section.name,
              subtitle: section.about,
              color: section.color,
              items: section.library_items.map do |item|
                {
                  name: item.name,
                  description: item.description,
                  item_class_name: item.item_class_name,
                  item_data: item.example_data
                }
              end
            }
          end,

          library_section_tabs: [welcome_tab] + library.library_sections.map do |section|
            {
              name: section.name,
              icon: section.icon,
              description: section.about,
              section_color: section.color
            }
          end,

          library_items: all_library_items
        }
      end

      def welcome_tab
        {
          name: "Welcome",
          icon: :house,
          description: "About the Library",
          section_color: "darkgray"
        }
      end

      def welcome_section
        {
          title: "Welcome",
          subtitle: "About the Dedalus library",
          color: 'darkgray',
          items: all_library_items
        }
      end

      def all_library_items
        LibraryItem.all.map do |item|
          {
            name: item.name,
            description: item.description,
            item_class_name: item.item_class_name,
            item_data: item.example_data
          }
        end
      end
    end
  end
end
