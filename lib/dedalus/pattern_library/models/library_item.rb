module Dedalus
  module PatternLibrary
    module Models
      class LibraryItem < Metacosm::Model
        attr_accessor :name, :kind, :description
        attr_accessor :item_class_name, :example_data
        belongs_to :library_section
      end
    end
  end
end
