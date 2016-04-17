require 'joyce'
require 'pry'

require 'dedalus/version'

module Dedalus
  class Element
    include PassiveRecord
    attr_accessor :position
    # % for elements in columsn/rows respectively
    attr_accessor :width, :height
  end

  class Atom < Element
  end

  class Molecule < Element
  end

  class Organism < Element
  end

  class Template < Element
  end

  class Page < Element
  end

  module ZOrder
    Background, Foreground, Text = *(0..3)
  end

  module Elements
    class Heading < Dedalus::Atom
      attr_accessor :text, :scale
      after_create { self.scale ||= 1.0 }

      # def dimensions(screen)
      #   [
      #     screen.font.height,
      #     screen.text_width(text)
      #   ]
      # end

      def render(screen)
        x,y = *position
        screen.font.draw(text, 20 + x, 20 + y, ZOrder::Text, self.scale, self.scale)
      end
    end
  end

  class ApplicationViewComposer
    attr_reader :app_view

    def initialize(app_view)
      @app_view = app_view
    end

    def window_dimensions
      [ app_view.window.width, app_view.window.height ]
    end

    def render!(structure, origin: [0,0], dimensions: window_dimensions)
      puts "--- called compose!"
      # structure = element.show
      p  origin: origin, dimensions: dimensions, structure: structure

      width, height = *dimensions
      x0, y0 = *origin

      if structure.is_a?(Dedalus::Atom)
        p rendering_atom: structure

        structure.update(position: origin)
        structure.render(app_view)

      elsif structure.is_a?(Dedalus::Element)
        # an element *other than* an atom, we need to call #show on it
        render!(structure.show, origin: origin, dimensions: dimensions)

      elsif structure.is_a?(Array) # we have a set of rows
        rows_with_height_hints = structure.select do |row| 
          if row.is_a?(Array)
            row.any? { |col| !col.height.nil? }
          else
            !row.height.nil? 
          end
        end
        height_specified_by_hints = rows_with_height_hints.sum(&:height) * height
        height_cursor = 0

        row_section_height = (height - height_specified_by_hints) / (structure.length)
        structure.each_with_index do |row, y_index|
          if row.is_a?(Array) # we have columns within the row
            columns_with_height_hints = row.select do |column|
              !column.width.nil?
            end
            width_specified_by_hints = columns_with_height_hints.sum(&:width) * width
            width_cursor = 0

            column_section_width = (width - width_specified_by_hints) / (row.length)
            row.each_with_index do |column, x_index|
              current_column_width = column.width.nil? ? column_section_width : (column.width * width)
              x = x0 + width_cursor
              y = y0 + height_cursor
              width_cursor += current_column_width
              render!(column, origin: [x,y], dimensions: [current_column_width, height])
            end
          else # no columns in the row
            current_row_height = row.height.nil? ? row_section_height : (row.height * height)
            x = x0
            y = y0 + height_cursor
            height_cursor += current_row_height
            render!(row, origin: [x,y], dimensions: [width, current_row_height])
          end
        end
      end
    end
  end

  module PatternLibrary
    class ApplicationView < Joyce::ApplicationView
      def render
        composer.render!(welcome_screen)
      end

      private
      def welcome_screen
        @welcome_screen ||= WelcomeScreen.create
      end

      def composer
        @composer ||= Dedalus::ApplicationViewComposer.new(self)
      end
    end

    class ApplicationHeader < Dedalus::Organism
      attr_accessor :title, :subtitle

      def show
        [ heading, subheading ]
      end

      private
      def heading
        @heading ||= Elements::Heading.create(text: title)
      end

      def subheading
        @subheading ||= Elements::Heading.create(text: subtitle, scale: 0.75)
      end
    end

    class ApplicationSidebar < Dedalus::Organism
      has_many :library_sections

      def show
        self.library_sections.all
      end
    end

    class LibrarySection < Dedalus::Molecule
      belongs_to :application_sidebar
      attr_accessor :name

      def show
        Elements::Heading.create(text: name) 
      end

      def height
        0.03
      end
    end

    class ApplicationScreen < Dedalus::Template
      def layout
        [
          page_header, [ sidebar, yield ]
        ]
      end

      private
      def page_header
        @page_header ||= ApplicationHeader.create(
          title: 'Dedalus',
          subtitle: 'A Visual Pattern Library for Joyce',
          height: 0.1
        )
      end

      def sidebar
        @sidebar ||= ApplicationSidebar.create(
          library_sections: [
            LibrarySection.create(name: "Home"),
            LibrarySection.create(name: "Atoms"),
            LibrarySection.create(name: "Molecules"),
            LibrarySection.create(name: "Organisms"),
            LibrarySection.create(name: "Templates"),
            LibrarySection.create(name: "Screens")
          ],
          width: 0.3
        )
      end
    end

    class WelcomeScreen < ApplicationScreen
      def show
        layout { welcome_message }
      end

      def welcome_message
        @welcome_message ||= Elements::Heading.create(text: "Welcome to our Pattern Library!")
      end
    end

    class Application < Joyce::Application
      viewed_with ApplicationView
    end
  end

  # class Molecule
  # end

  # class Organism
  # end

  # class Template
  #   def assemble(*)
  #     puts "warning: template #{self.class.name} does not override #assemble"
  #     []
  #   end
  # end

  # class Page
  #   attr_reader :organisms

  #   def insert(organism)
  #     @organisms ||= []
  #     @organisms << organism
  #   end

  #   def render(window:)
  #     ctx = DrawingContext.new(window)
  #     organisms.each do |organism|
  #       organism.render
  #     end
  #   end

  #   class DrawingContext
  #   end
  # end

  # ###

  # module Elements
  #   class Heading < Dedalus::Atom
  #     attr_reader :text

  #     def render(context:)
  #       x,y = *context.location
  #       context.window.font.draw(text, x, y, 1)
  #     end
  #   end
  # end

  # module Compounds
  #   # class Search < Dedalus::Molecule; end
  #   # class Jumbotron < Dedalus::Molecule
  #   # end
  # end

  # module Bestiary
  #   class Jumbotron < Dedalus::Organism

  #   end
  # end

  # # module Scaffolds
  # #   class Jumbotron < Dedalus::Template
  # #   end
  # # end

  # ###
  # #

  # module Library
  #   class ApplicationTemplate < Dedalus::Tempalte
  #     def hydrate(welcome_message:)
  #       page = Page.new
  #       page.insert(Jumbotron.new(text: welcome_message))
  #       page
  #     end
  #   end

  #   class ApplicationView < Joyce::ApplicationView
  #     def render
  #       p [ :render_app_view! ]
  #       page = ApplicationTemplate.hydrate(application_data)
  #       page.render
  #     end

  #     def application_data
  #       {
  #         welcome_message: "Hello, user!"
  #       }
  #     end
  #   end

  #   class Application < Joyce::Application
  #     viewed_with ApplicationView
  #   end
  # end
end
