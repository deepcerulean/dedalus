module Dedalus
  module Elements
    class Text < Dedalus::Atom
      attr_accessor :text, :scale, :padding

      def render(*)
        x,y = *position
        font.draw(text, x + padding, y + padding, z_order, self.scale, self.scale)

        # draw_bounding_box(origin: [x,y], dimensions: dimensions)
      end

      def width
        2*padding + (font.text_width(text) * scale)
      end

      def height
        2*padding + (font.height * scale)
      end

      def padding
        @padding ||= 0.0
      end

      def scale
        @scale ||= 1.0
      end

      def dimensions
        [ width, height ]
      end

      # sample data for the explorer...
      def self.example_data
        { text: "Hello World" }
      end

      def self.description
        "words"
      end
    end
  end
end
