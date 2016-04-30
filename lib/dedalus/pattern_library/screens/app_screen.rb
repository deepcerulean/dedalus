module Dedalus
  module PatternLibrary
    class ApplicationScreen < Dedalus::Screen
      def initialize(template)
        @template = template
      end

      def show
        layers
      end

      def layers
        layer_stack = Dedalus::LayerStack.new
        layer_stack.push(Dedalus::Layer.new(background_image))
        layer_stack.push(Dedalus::Layer.new(@template))
        layer_stack.push(Dedalus::Layer.new(cursor, freeform: true))
        layer_stack
      end

      def background_image
        @bg_image ||= Elements::Image.new(path: "media/images/cosmos.jpg", z_order: -1)
      end

      def cursor
        @cursor ||= Elements::Icon.for :arrow_cursor
      end

      def hydrate(mouse_position:, library_section_tabs:, current_entry_name:, library_sections:, library_items:)
        @template.library_name = "Dedalus Pattern Library"
        @template.library_section_tabs = library_section_tabs
        @template.library_sections = library_sections
        @template.library_items = library_items
        @template.current_entry_name = current_entry_name

        cursor.position = mouse_position

        self
      end
    end
  end
end
