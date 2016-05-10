module Dedalus
  module Elements
    class ImageGrid < Dedalus::Molecule
      attr_accessor :grid, :tiles_path, :tile_width, :tile_height
      attr_accessor :scale

      def show
        if grid
          grid.map do |row_elements|
            row_elements.map do |grid_value|
              if grid_value
                sprite_for(grid_value)
              else
                no_image
              end
            end
          end
        else
          []
        end
      end

      def name
        @name ||= 'an-image-grid' # a uniq id for recording
      end

      def scale
        @scale ||= 1.0
      end

      def record?
        grid && !grid.empty?
      end

      def width
        if grid && grid.first
          grid.first.length * tile_width * scale
        else
          0
        end
      end

      def height
        if grid
          grid.length * tile_height * scale
        else
          0
        end
      end

      def sprite_for(frame)
        Sprite.new(
          frame: frame,
          asset_width: tile_width,
          asset_height: tile_height,
          path: tiles_path,
          scale: scale
        )
      end

      def no_image
        Void.new(height: tile_height * scale, width: tile_width * scale)
      end

      def self.description
        "a grid of images"
      end

      def self.example_data
        {
          tiles_path: "media/images/tiles.png",
          tile_width: 64,
          tile_height: 64,
          scale: 0.2,
          grid: [
            [ nil, 0, 2, 0, 1 ],
            [ 0, nil, 1, 0, 1 ],
            [ 0, 0, nil, 0, 1 ],
            [ 0, 1, 2, nil, 1 ],
          ]
        }
      end
    end
  end
end
