module Dedalus
  module PatternLibrary
    module Models
      class LibrarySection < Metacosm::Model
        attr_accessor :name, :about, :description, :icon, :color
        belongs_to :library
        has_many :library_items
      end
    end
  end
end
