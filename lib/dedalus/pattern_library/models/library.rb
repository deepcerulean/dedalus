module Dedalus
  module PatternLibrary
    module Models
      class Library < Metacosm::Model
        attr_accessor :name
        has_many :library_sections
      end
    end
  end
end
