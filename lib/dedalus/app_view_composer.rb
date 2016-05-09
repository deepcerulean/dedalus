module Dedalus
  class ApplicationViewComposer
    include Geometer::PointHelpers
    include Geometer::DimensionHelpers

    def traverse(structure, origin: [0,0], dimensions:, render: false, &blk)
      traversal = ViewTraversal.new(&blk)
      traversal.walk!(structure, origin: origin, dimensions: dimensions, render: render)
      structure
    end

    def send_molecule(structure, window_dims, mouse_position:, message:)
      mouse_coord = coord(*mouse_position)

      traverse(structure, origin: [0,0], dimensions: window_dims) do
        on_molecule do |molecule, origin:, dimensions:|
          element_bounding_box = Geometer::Rectangle.new(coord(*origin), dim(*dimensions))
          mouse_overlap = element_bounding_box.contains?(mouse_coord) rescue false # could get bad coords...
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
      send_molecule(structure, window_dims, mouse_position: mouse_position, message: :click)
    end

    def render!(structure, dims)
      traverse(structure, origin: [0,0], dimensions: dims, render: true) do
        on_atom do |atom, origin:, dimensions:, freeform:|
          if atom.background_color
            atom.draw_bounding_box(
              color: atom.background_color,
              origin: origin,
              dimensions: dimensions
            )
          end

          if freeform # then offset by origin
            x0,y0 = *origin
            x,y = *atom.position
            atom.position = [x+x0,y+y0]
          else
            atom.position = origin
          end

          atom.render
        end

        on_element do |element, origin:, dimensions:|
          if element.background_color
            element.draw_bounding_box(
              color: element.background_color,
              origin: origin,
              dimensions: dimensions
            )
          end

          element.position = origin
        end
      end
    end
  end
end
