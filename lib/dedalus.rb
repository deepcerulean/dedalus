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
    attr_accessor :scale
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
    class Icon < Dedalus::Atom
      attr_accessor :image #, :layer
      after_create { self.scale ||= 0.0618 }

      def render(screen)
        x,y = *position
        p [ :draw_image, pos: [x,y], img: image ]
        image.draw(x, y, ZOrder::Foreground, scale, scale)
      end

      class << self
        def for(sym)
          @icon_set ||= {}
          @icon_set[sym] ||= create(image: Gosu::Image.new("media/icons/#{sym}.png"))
          @icon_set[sym]
        end
      end
    end

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

    class Paragraph < Dedalus::Atom
      attr_accessor :text, :scale
      after_create { self.scale ||= 0.5 }

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
      # puts "--- called render!"
      # # structure = element.show

      width, height = *dimensions
      x0, y0 = *origin

      if structure.is_a?(Dedalus::Atom)

        structure.update(position: origin)
        structure.render(app_view)

      elsif structure.is_a?(Dedalus::Element)
        # an element *other than* an atom, we need to call #show on it
        render!(structure.show, origin: origin, dimensions: dimensions)

      elsif structure.is_a?(Array) # we have a set of rows
        rows_with_height_hints = structure.select do |row| 
          if row.is_a?(Array)
            false #row.any? { |col| !col.height.nil? }
          else
            !row.height.nil? 
          end
        end

        height_specified_by_hints = rows_with_height_hints.sum(&:height) * height.to_f
        height_cursor = 0

        row_section_height = (height - height_specified_by_hints) / (structure.length - rows_with_height_hints.length) #.to_f)
        structure.each_with_index do |row, y_index|
          if row.is_a?(Array) # we have columns within the row
            columns_with_height_hints = row.select do |column|
              !column.width.nil?
            end
            width_specified_by_hints = columns_with_height_hints.sum(&:width) * width.to_f
            width_cursor = 0

            column_section_width = (width - width_specified_by_hints) / (row.length - columns_with_height_hints.length) #.to_f)
            row.each_with_index do |column, x_index|

              current_column_width = column.width.nil? ? column_section_width : (column.width * width)
              x = x0 + width_cursor
              y = y0 + height_cursor
              render!(column, origin: [x,y], dimensions: [current_column_width, height])

              width_cursor += current_column_width
            end

            height_cursor += row_section_height
          else # no columns in the row
            current_row_height = row.height.nil? ? row_section_height : (row.height * height)
            x = x0
            y = y0 + height_cursor
            dims = [width, current_row_height]
            render!(row, origin: [x,y], dimensions: dims)

            height_cursor += current_row_height
          end
        end
      end
    end
  end

  module PatternLibrary
    class ApplicationView < Joyce::ApplicationView
      def render
        composer.render!(welcome_screen)

        cursor = Elements::Icon.for(:arrow_cursor)
        cursor.update(position: mouse_position)
        cursor.render(self)
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

    class ApplicationFooter < Dedalus::Organism
      attr_accessor :joyce_version, :dedalus_version, :company, :copyright

      def show
        [ footer_message ]
      end

      def height
        0.1
      end

      private
      def footer_message
        @footer_message ||=  Elements::Paragraph.create(text: assemble_text)
      end

      def assemble_text
        "Powered by Dedalus v#{dedalus_version} and Joyce v#{joyce_version}. Copyright #{company} #{copyright}, all rights reserved."
      end
    end

    class LibrarySection < Dedalus::Molecule
      belongs_to :application_sidebar
      attr_accessor :name

      def show
        Elements::Heading.create(text: name)
      end

      def height
        0.1
      end
    end


    class ApplicationScreen < Dedalus::Template
      def layout
        [
          app_header, 
          [ sidebar, yield ],
          app_footer
        ]
      end

      private
      def app_header
        @app_header ||= ApplicationHeader.create(
          title: 'Dedalus',
          subtitle: 'A Visual Pattern Library for Joyce',
          height: 0.1
        )
      end

      def app_footer
        @app_footer ||= ApplicationFooter.create(
          joyce_version: Joyce::VERSION,
          dedalus_version: Dedalus::VERSION,
          company: "Deep Cerulean Simulations and Games",
          copyright: "2015-#{Time.now.year}"
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
end
