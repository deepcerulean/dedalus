require 'joyce'
require 'geometer'

require 'dedalus/version'

module Dedalus
  class Element
    include PassiveRecord
    attr_accessor :position
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

  module PatternLibrary
    class ApplicationView < Joyce::ApplicationView
      def render
        compose!(welcome_screen) #(self)
      end

      private
      def welcome_screen
        @welcome_screen ||= WelcomeScreen.create
      end

      # [ row1, [ row2-col1, row2-col2 ], row3 ... ]
      def compose!(structure, origin: [0,0], dimensions: [window.width, window.height])
        puts "--- called compose!" 
        # structure = element.show
        p  origin: origin, dimensions: dimensions, structure: structure


        width, height = *dimensions
        x0, y0 = *origin

        if structure.is_a?(Dedalus::Atom)
          p rendering_atom: structure
          
          structure.update(position: origin)
          structure.render(self)

        elsif structure.is_a?(Dedalus::Element)
          # an element *other than* an atom, we need to call #show on it
          compose!(structure.show, origin: origin, dimensions: dimensions)

        elsif structure.is_a?(Array) # we have a set of rows, assume divided evenly?
          structure.each_with_index do |row, y_index|
            if row.is_a?(Array) # we have columns within the row
              raise "no columns yet"
              # row.each_with_index do |column, x_index|
              #   # ...
              #   # column_section_width = width / (row.length)
              # end
            else # no columns in the row, just need to compute new offsets...
              # ...
              row_section_height = height / (structure.length)
              x = x0
              y = y0 + (row_section_height * (y_index))
              compose!(row, origin: [x,y], dimensions: [width, row_section_height])
            end
          end
        end
      end
    end

    class ApplicationHeader < Dedalus::Organism
      attr_accessor :title, :subtitle

      def show
        [ heading, subheading ]
      end

      # def render(screen)
      #   heading.render(screen)
      #   subheading.render(screen)
      # end

      private
      def heading
        @heading ||= Elements::Heading.create(text: title)
      end

      def subheading
        @subheading ||= Elements::Heading.create(text: subtitle, scale: 0.75)
      end
    end

    class ApplicationScreen < Dedalus::Template
      def page_header
        @page_header ||= ApplicationHeader.create(
          title: 'Dedalus',
          subtitle: 'A Visual Pattern Library for Joyce'
        )
      end
    end

    class WelcomeScreen < ApplicationScreen
      def show
        [ page_header, welcome_message ]
      end

      # def render(screen)
      #   page_header.render(screen)
      #   welcome_message.render(screen)
      # end

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
