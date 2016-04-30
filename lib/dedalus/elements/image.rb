module Dedalus
  module Elements
    class Image < Dedalus::Atom
      attr_accessor :path, :padding, :z_order

      def render
        x,y = *position
        asset.draw(x + padding, y + padding, z_order, scale, scale)
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
        { path: "media/icons/house.png" }
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
