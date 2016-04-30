module Dedalus
  module Elements
    class Sprite < Image
      attr_accessor :width, :height, :frame

      def asset
        @asset ||= Dedalus::ImageRepository.lookup_tiles(path, width, height)[frame]
      end

      def self.example_data
        {
          path: "media/images/tiles.png",
          frame: 0,
          width: 64,
          height: 64
        }
      end

      def self.description
        "an animated image"
      end
    end
  end
end
