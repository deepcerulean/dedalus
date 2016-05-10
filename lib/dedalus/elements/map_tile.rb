module Dedalus
  module Elements
    class MapTile < Dedalus::Molecule
      attr_accessor :frame, :asset_width, :asset_height, :path, :scale

      attr_accessor :highlight

      def show
        tile_sprite
      end

      def tile_sprite
        Sprite.new(
          frame: frame,
          asset_width: asset_width,
          asset_height: asset_height,
          path: path,
          scale: scale
        )
      end

      def self.description
        'example of a custom tile class for image grid/sprite field'
      end

      def self.example_data
        Sprite.example_data
      end
    end
  end
end
