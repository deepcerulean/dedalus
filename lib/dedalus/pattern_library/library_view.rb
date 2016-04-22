module Dedalus
  module PatternLibrary
    class LibraryView < Metacosm::View
      attr_accessor :library_name, :library_section_tabs, :library_sections
      belongs_to :application_view
    end
  end
end
