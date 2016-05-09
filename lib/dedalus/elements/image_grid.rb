module Dedalus
  module Elements
    # TODO image grid should learn to use window#record http://www.rubydoc.info/github/jlnr/gosu/Gosu%2FWindow%3Arecord
    class ImageGrid < Dedalus::Molecule
      attr_accessor :grid, :tiles_path, :tile_width, :tile_height
      attr_accessor :recorded_image

      def name
        'an-image-grid' # we record these, so... we need a unique identifier that will persist across invocations -- in general we'll only be using one, but if they're layered you may need to differentiate...
      end

      def record?
        !grid.empty?
      end

      def width
        if grid && grid.first
          grid.first.length * tile_width
        else
          0
        end
      end

      def height
        if grid
          grid.length * tile_height
        else
          0
        end
      end

      def show
        if grid
          grid.map do |row|
            row.map do |grid_value|
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

      def height
        if grid
          grid.length * tile_height
        else
          0
        end
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
