module Dedalus
  class ApplicationViewComposer
    include Geometer::PointHelpers
    include Geometer::DimensionHelpers

    def traverse(structure, origin: [0,0], dimensions:, &blk)
      traversal = ViewTraversal.new(&blk)
      traversal.walk!(structure, origin: origin, dimensions: dimensions)
      structure
    end

    def send_molecule(structure, window_dims, mouse_position:, message:) #, origin: [0,0], dimensions:, mouse_position:)
      mouse_coord = coord(*mouse_position)

      traverse(structure, origin: [0,0], dimensions: window_dims) do
        on_molecule do |molecule, origin:, dimensions:|
          element_bounding_box = Geometer::Rectangle.new(coord(*origin), dim(*dimensions))
          mouse_overlap = element_bounding_box.contains?(mouse_coord)
          if mouse_overlap
            molecule.send(message) 
          end
        end
      end
    end

    def hover_molecule(structure, window_dims, mouse_position:)
      send_molecule(structure, window_dims, mouse_position: mouse_position, message: :hover)
    end

    def click_molecule(structure, window_dims, mouse_position:)
      # p [ :CLICK_MOLECULE ]
      send_molecule(structure, window_dims, mouse_position: mouse_position, message: :click)
    end

    def render!(structure, dims)
      traverse(structure, origin: [0,0], dimensions: dims) do
        on_atom do |atom, origin:, dimensions:|
          atom.position = origin
          atom.render
        end

        on_element do |element, origin:, dimensions:|
          x0,y0 = *origin
          width,height = *dimensions

          pad = element.padding || 5.0
          pad_origin = [x0 + pad, y0 + pad ]
          pad_dims = [width - pad*2, height - pad*2 ]

          if element.background_color
            element.draw_bounding_box(
              color: element.background_color,
              origin: pad_origin, 
              dimensions: pad_dims
            )
          end
        end
      end
    end
  end
end
