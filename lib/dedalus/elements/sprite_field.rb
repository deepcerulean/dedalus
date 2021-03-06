module Dedalus
  module Elements
    class SpriteField < Dedalus::Organism
      attr_accessor :grid, :sprite_map, :scale, :camera_location
      attr_accessor :tile_width, :tile_height, :tiles_path, :tile_class
      attr_accessor :redraw_tiles

      def show
        layers
      end

      def camera_offset
        if camera_location
          cx,cy = *camera_location
          [-cx * (tile_width*scale), -cy * (tile_height*scale)]
        else
          [0,0]
        end
      end

      def layers
        layer_stack = Dedalus::LayerStack.new
        layer_stack.push(Dedalus::Layer.new(background_image)) if background_image
        layer_stack.push(Dedalus::Layer.new(image_grid))
        layer_stack.push(canvas_layer)
        layer_stack
      end

      def canvas_layer
        Dedalus::Layer.new(sprites, freeform: true)
      end

      def sprites
        sprite_map.flat_map do |location, sprite_list|
          sprite_list.map do |sprite|
            position = to_screen_coordinates(location: location)
            sprite.position = position
            sprite
          end
        end
      end

      def image_grid
        ImageGrid.new(
          tiles_path: tiles_path,
          grid: grid,
          tile_width: tile_width,
          tile_height: tile_height,
          tile_class: tile_class,
          scale: scale,
          offset: camera_offset,
          name: 'sprite-field-tiles',
          redraw_tiles: redraw_tiles
        )
      end

      def to_screen_coordinates(location:)
        w,h = tile_width, tile_height
        x,y = *location
        cx,cy = *camera_offset
        [(x * w * scale) + cx, (y * h * scale) + cy]
      end

      def background_image
        @background_image ||= nil
      end

      def self.description
        'sprites overlaid on an image grid'
      end

      def self.example_data
        {
          grid: [[0,2,0,0,0],
                 [0,0,0,0,0],
                 [1,1,3,1,1],
                 [1,1,1,1,1]],
          scale: 2.0,
          camera_location: [1.2,2.4],
          tiles_path: "media/images/tiles.png",
          tile_width: 64,
          tile_height: 64,
          tile_class: "Dedalus::Elements::MapTile",
          sprite_map: {
            [1.2,2.4] => [ Sprite.new(Sprite.example_data) ]
          }
        }
      end
    end
  end
end
