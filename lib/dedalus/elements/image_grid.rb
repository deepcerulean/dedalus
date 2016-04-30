module Dedalus
  module Elements
    class ImageGrid < Dedalus::Molecule
      attr_accessor :grid, :tiles_path, :tile_width, :tile_height

      def show
        grid.map do |row|
          row.map do |grid_value|
            if grid_value
              sprite_for(grid_value)
            else
              no_image
            end
          end
        end
      end

      def height
        grid.length * tile_height
      end

      def sprite_for(frame)
        Sprite.new(frame: frame, width: tile_width, height: tile_height, path: tiles_path)
      end

      def no_image
        Void.new(height: tile_height, width: tile_width)
      end

      def self.description
        "a grid of images"
      end

      def self.example_data
        {
          tiles_path: "media/images/tiles.png",
          tile_width: 64,
          tile_height: 64,
          grid: [
            [ nil, 0, 2, 0 ],
            [ 0, nil, 1, 0 ],
            [ 0, 0, nil, 0 ],
            [ 0, 1, 2, nil ],
          ]
        }
      end
    end

  end
end
