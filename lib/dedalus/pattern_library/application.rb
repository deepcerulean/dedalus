module Dedalus
  module PatternLibrary
    class Application < Joyce::Application
      viewed_with ApplicationView
      include Models

      def click
        p [ :app_click ]
        view.click
      end

      def setup(module_to_search:, library_name:)
        create_library(name: library_name, module_to_search: module_to_search)
      end

      def find_descendants_of(klass, module_to_search)
        ObjectSpace.each_object(Class).select { |k| k < klass && k.name.deconstantize == module_to_search.name }
      end

      def create_library(module_to_search:, name:)
        library = Library.create(name: name)

        atom_section = library.create_library_section(
          name: "Atoms",
          icon: :atom,
          color: 'darkred',
          about: "Components that can't be split further"
        )

        atom_classes = find_descendants_of(Dedalus::Atom, module_to_search)
        atom_section.build_items_from_classes(atom_classes, kind: 'atom')

        molecules_section = library.create_library_section(
          name: "Molecules",
          icon: :molecule,
          color: 'yellow',
          about: "Simple compounds of a few atoms"
        )

        molecule_classes = find_descendants_of(Dedalus::Molecule, module_to_search)
        molecules_section.build_items_from_classes(molecule_classes, kind: 'molecule')

        organism_section = library.create_library_section({
          name: "Organisms",
          icon: :paramecium,
          color: 'green',
          about: "Highly-complex assemblages of molecules"
        })

        organism_classes = find_descendants_of(Dedalus::Organism, module_to_search)
        organism_section.build_items_from_classes(organism_classes, kind: 'organism')

        template_section = library.create_library_section({
          name: "Templates",
          icon: :hive,
          color: 'blue',
          about: "Assembled screens with placeholders"
        })

        template_classes = find_descendants_of(Dedalus::Template, module_to_search)
        template_section.build_items_from_classes(template_classes, kind: 'template')

        # template_section.create_library_item({
        #   name: "Library Template",
        #   item_class_name: 'Dedalus::PatternLibrary::ApplicationTemplate',
        #   description: "ui library app template",
        #   example_data: ApplicationTemplate.example_data
        # })

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
                  kind: item.kind,
                  color: section.color,
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
          show_table: true,
          items: all_library_items
        }
      end

      def all_library_items
        LibraryItem.all.map do |item|
          {
            name: item.name,
            kind: item.kind,
            color: item.color,
            description: item.description,
            item_class_name: item.item_class_name,
            item_data: item.example_data
          }
        end
      end
    end
  end
end
