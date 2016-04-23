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

        atom_classes = find_descendants_of(Dedalus::Atom)
        atom_section.build_items_from_classes(atom_classes)

        molecules_section = library.create_library_section(
          name: "Molecules",
          icon: :molecule,
          color: 'yellow',
          about: "Simple compounds of a few atoms"
        )

        molecule_classes = find_descendants_of(Dedalus::Molecule)
        molecules_section.build_items_from_classes molecule_classes
        
        organism_section = library.create_library_section({
          name: "Organisms",
          icon: :paramecium,
          color: 'green',
          about: "Highly-complex assemblages of molecules"
        })

        organism_classes = find_descendants_of(Dedalus::Organism)
        organism_section.build_items_from_classes organism_classes
        
        library.create_library_section({
          name: "Templates",
          icon: :hive,
          color: 'blue',
          about: "Assembled screens with placeholders"})

        # just manually create a view from models for now...

        view.library_view = LibraryView.create(
          library_name: library.name,

          library_sections: library.library_sections.map do |section|
            {
              title: section.name,
              subtitle: section.about,
              color: section.color,
              items: section.library_items.map do |item|
                {
                  name: item.name,
                  # kind: item.kind,
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
