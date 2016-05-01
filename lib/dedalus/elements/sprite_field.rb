module Dedalus
  module Elements
    class SpriteField < Dedalus::Organism

      attr_accessor :grid, :sprite_map, :scale

      def show
        layers
      end

      def layers
        layer_stack = Dedalus::LayerStack.new
        layer_stack.push(Dedalus::Layer.new(background_image))
        layer_stack.push(Dedalus::Layer.new(image_grid))

        # TODO one sprite *layer*
        sprite_map.each do |location, sprite_list|
          sprite_list.each do |sprite_attrs|
            position = to_screen_coordinates(location: location)
            sprite = Sprite.new(sprite_attrs.merge(position: position))
            layer_stack.push(Dedalus::Layer.new(sprite, freeform: true))
          end
        end

        layer_stack
      end

      def image_grid
        ImageGrid.new(
          tiles_path: 'media/images/tiles.png',
          grid: grid,
          tile_width: 64,
          tile_height: 64
        )
      end

      def to_screen_coordinates(location:)
        x,y = *location
        [(x * image_grid.tile_width), (y * image_grid.tile_height)]
      end

      def background_image
        Image.new(path: "media/images/cosmos.jpg", z_order: -1, scale: self.scale)
      end

      def self.description
        'sprites overlaid on an image grid'
      end

      def self.example_data
        {
          grid: [[0,0,0,0,0],
                 [0,0,0,0,0],
                 [1,1,1,1,1],
                 [1,1,1,1,1]],
          scale: 0.3,
          player_location: [2,2],
          sprite_map: { [0,0] => [ Sprite.example_data ] }
        }
      end
    end
  end
end
