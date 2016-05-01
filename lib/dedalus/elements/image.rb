module Dedalus
  module Elements
    class Image < Dedalus::Atom
      attr_accessor :path, :padding, :z_order, :invert_x, :invert_y

      def render
        x,y = *position
        x_scale = invert_x ? -scale : scale
        y_scale = invert_y ? -scale : scale

        ox,oy = *offset

        asset.draw(x + padding + ox, y + padding + oy, z_order, x_scale, y_scale)
      end

      def offset
        if invert_x
          [ width, 0 ]
        elsif invert_y
          [ 0, height ]
        else
          [ 0, 0 ]
        end
      end

      def z_order
        @z_order ||= ZOrder::Foreground
      end

      def width
        2*padding + (asset.width * scale)
      end

      def height
        2*padding + (asset.height * scale)
      end

      def dimensions
        [ width, height ]
      end

      def padding
        @padding ||= 0.0
      end

      def scale
        @scale ||= 1.0
      end

      def self.example_data
        { path: "media/images/cosmos.jpg", scale: 0.2, invert_y: true }
      end

      def self.description
        "an image"
      end

      def asset
        @asset ||= Dedalus::ImageRepository.lookup(path)
      end
    end
  end
end
