module Dedalus
  module PatternLibrary
    module Models
      class LibraryItem < Metacosm::Model
        attr_accessor :name, :kind, :description
        belongs_to :library_section
      end
    end
  end
end
