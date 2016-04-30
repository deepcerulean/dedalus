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
      traverse(structure, origin: [0,0], dimensions: dims) do
        on_atom do |atom, origin:, dimensions:, freeform:|
          if atom.background_color
            atom.draw_bounding_box(
              color: atom.background_color,
              origin: origin,
              dimensions: dimensions
            )
          end

          atom.position = origin unless freeform
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
        end
      end
    end
  end
end
