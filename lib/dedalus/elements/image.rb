module Dedalus
  module Elements
    class Image < Dedalus::Atom
      attr_accessor :path, :padding, :z_order, :invert_x, :invert_y, :overlay_color

      def render
        x0,y0 = *position
        ox,oy = *offset

        x_scale = invert_x ? -scale : scale
        y_scale = invert_y ? -scale : scale

        x,y = x0 + padding + ox, y0 + padding + oy

        if overlay_color
          asset.draw(x,y, z_order, x_scale, y_scale, overlay_gosu_color)
        else
          asset.draw(x,y, z_order, x_scale, y_scale)
        end
      end

      def overlay_gosu_color
        clr = Palette.decode_color(overlay_color).to_gosu
        clr.alpha = 255
        clr
      end

      def offset
        ox = invert_x ? width : 0
        oy = invert_y ? height : 0
        [ ox, oy ]
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
        { path: "media/images/cosmos.jpg", scale: 0.2, invert_y: true, invert_x: true }
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
