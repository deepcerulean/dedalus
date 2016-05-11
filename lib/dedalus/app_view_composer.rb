module Dedalus
  class ApplicationViewComposer
    include Geometer::PointHelpers
    include Geometer::DimensionHelpers

    def traverse(structure, origin: [0,0], dimensions:, render: false, &blk)
      traversal = ViewTraversal.new(&blk)
      traversal.walk!(structure, origin: origin, dimensions: dimensions, render: render)
    end

    def send_molecule(structure, window_dims, mouse_position:, message:)
      mouse_coord = coord(*mouse_position)

      traverse(structure, origin: [0,0], dimensions: window_dims, render: false) do
        on_molecule do |molecule, origin:, dimensions:, z_index:|
          element_bounding_box = Geometer::Rectangle.new(coord(*origin), dim(*dimensions))
          mouse_overlap = element_bounding_box.contains?(mouse_coord) rescue false # could get bad coords...
          if mouse_overlap
            molecule.position = origin
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
        on_atom do |atom, origin:, dimensions:, freeform:, z_index:|
          if atom.background_color
            atom.draw_bounding_box(
              color: atom.background_color,
              origin: origin,
              dimensions: dimensions
            )
          end

          # TODO may need to do this to get click/hover events for sprites?
          if freeform # then offset by origin 
            x0,y0 = *origin
            x,y = *atom.position
            atom.position = [x+x0,y+y0]
          else
            atom.position = origin
          end

          atom.z_order = z_index

          atom.render
        end

        on_element do |element, origin:, dimensions:, z_index:|
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
