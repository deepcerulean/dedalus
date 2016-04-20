module Dedalus
  module Elements
    class Image < Dedalus::Atom
      attr_accessor :path, :padding

      def render
        x,y = *position
        asset.draw(x + padding, y + padding, ZOrder::Foreground, scale, scale)
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
        @padding ||= 10.0
      end

      private
      def asset
        @asset ||= Gosu::Image.new(path)
      end
    end
  end
end
