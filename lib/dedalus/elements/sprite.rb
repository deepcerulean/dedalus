module Dedalus
  module Elements
    class Sprite < Image
      attr_accessor :asset_width, :asset_height, :frame

      def asset
        @asset ||= Dedalus::ImageRepository.lookup_tiles(path, asset_width, asset_height)[frame]
      end

      def scale
        @scale ||= 1.0
      end

      def width
        2*padding + (asset_width * scale)
      end

      def height
        2*padding + (asset_height * scale)
      end

      def self.example_data
        {
          path: "media/images/tiles.png",
          frame: 3,
          asset_width: 64,
          asset_height: 64,
          invert_x: true,
          scale: 2.5
        }
      end

      def self.description
        "an animated image"
      end
    end
  end
end
