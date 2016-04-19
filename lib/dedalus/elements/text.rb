module Dedalus
  module Elements
    class Text < Dedalus::Atom
      attr_accessor :text, :scale, :padding

      def font
        screen.font
      end

      def render(*)
        x,y = *position
        font.draw(text, x + padding, y + padding, ZOrder::Text, self.scale, self.scale)

        # draw_bounding_box(origin: [x,y], dimensions: dimensions)
      end

      def width
        2*padding + (font.text_width(text) * scale)
      end

      def height
        2*padding + (font.height * scale)
      end

      def dimensions
        [ width, height ]
      end
    end
  end
end
