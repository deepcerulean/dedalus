module Dedalus
  module PatternLibrary
    module Models
      class LibrarySection < Metacosm::Model
        attr_accessor :name, :about, :description, :icon, :color
        belongs_to :library
        has_many :library_items

        def build_items_from_classes(klasses, kind:)
          klasses.each do |klass|
            item_name = klass.name.to_s

            create_library_item(
              name: item_name.demodulize.titleize,
              color: self.color,
              kind: kind,
              item_class_name: item_name,
              description: klass.description,
              example_data: klass.example_data
            )
          end
        end
      end
    end
  end
end
