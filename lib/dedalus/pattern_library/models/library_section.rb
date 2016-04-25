module Dedalus
  module PatternLibrary
    module Models
      class LibrarySection < Metacosm::Model
        attr_accessor :name, :about, :description, :icon, :color
        belongs_to :library
        has_many :library_items

        def build_items_from_classes(klasses, kind:)
          klasses.each do |klass|
            name = klass.name.to_s
            create_library_item(
              name: name.demodulize.titleize,
              kind: kind,
              item_class_name: name,
              description: klass.description,
              example_data: klass.example_data
            )
          end
        end
      end
    end
  end
end
