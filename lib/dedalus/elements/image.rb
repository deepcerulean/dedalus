module Dedalus
  module Elements
    class ImageRepository
      def self.lookup(path)
        @images ||= {}
        @images[path] ||= Gosu::Image.new(path)
        @images[path]
      end
    end

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

      def scale
        @scale ||= 1.0
      end

      def self.example_data
        { path: "media/icons/house.png" }
      end

      def self.description
        "an image"
      end

      private
      def asset
        @asset ||= ImageRepository.lookup(path)
      end
    end
  end
end
