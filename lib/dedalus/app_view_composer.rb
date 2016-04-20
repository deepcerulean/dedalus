module Dedalus
  class ViewTraversal

    include Geometer::PointHelpers
    include Geometer::DimensionHelpers

    def initialize(&blk)
      instance_eval(&blk)
    end

    def on_atom(&blk)
      @atom_callback = blk
    end

    def on_molecule(&blk)
      @molecule_callback = blk
    end

    # TODO callback on every element (for bg colors for higher order things than molecules)
    # def on_element(&blk)
    #   @element_callback = blk
    # end

    def walk!(structure, origin:, dimensions:)
      width, height = *dimensions
      x0, y0 = *origin

      if structure.is_a?(Dedalus::Atom)
        @atom_callback.call(structure, origin: origin, dimensions: dimensions) if @atom_callback
      elsif structure.is_a?(Dedalus::Element)
        # an element *other than* an atom, we need to call #show on it
        pad = structure.padding || 5.0
        pad_origin = [x0 + pad, y0 + pad ]
        pad_dims = [width - pad*2, height - pad*2 ]

        @molecule_callback.call(structure, origin: pad_origin, dimensions: pad_dims) if structure.is_a?(Dedalus::Molecule) && @molecule_callback
        walk!(structure.show, origin: pad_origin, dimensions: pad_dims)

      elsif structure.is_a?(Array) # we have a set of rows
        rows_with_percentage_height_hints = structure.select do |row|
          if row.is_a?(Array)
            false
          else
            !row.height_percent.nil?
          end
        end

        rows_with_raw_height_hints = structure.select do |row|
          if row.is_a?(Array)
            false
          else
            !row.height.nil?
          end
        end

        rows_with_height_hints = rows_with_percentage_height_hints + rows_with_raw_height_hints

        height_specified_by_hints =
          (rows_with_percentage_height_hints.sum(&:height_percent) * height) +
          (rows_with_raw_height_hints.sum(&:height))

        height_cursor = 0

        row_section_height = (height - height_specified_by_hints) / (structure.length - rows_with_height_hints.length)
        structure.each_with_index do |row, y_index|
          if row.is_a?(Array) # we have columns within the row
            columns_with_percentage_width_hints = row.select do |column|
              if column.is_a?(Array)
                false
              else
                !column.width_percent.nil?
              end
            end

            columns_with_raw_width_hints = row.select do |column|
              if column.is_a?(Array)
                false
              else
                !column.width.nil?
              end
            end

            columns_with_width_hints = columns_with_percentage_width_hints + columns_with_raw_width_hints

            width_specified_by_hints =
              (columns_with_percentage_width_hints.sum(&:width_percent) * width.to_f) +
              (columns_with_raw_width_hints.sum(&:width))

            width_cursor = 0

            column_section_width = (width - width_specified_by_hints) / (row.length - columns_with_width_hints.length)
            row.each_with_index do |column, x_index|
              if column.is_a?(Array) # we have rows INSIDE the columns! i think we need to recurse...
                new_origin = [x0 + width_cursor,y0 + height_cursor]
                new_dims = [ column_section_width, row_section_height ]
                walk!(column, origin: new_origin, dimensions: new_dims)

                # render!(column, origin: [x0 + width_cursor,y0 + height_cursor], dimensions: [column_section_width, row_section_height], mouse_position: mouse_position)
              else
                current_column_width = if !column.width.nil?
                                         column.width
                                       elsif !column.width_percent.nil?
                                         column.width_percent * width
                                       else
                                         column_section_width
                                       end
                x = x0 + width_cursor
                y = y0 + height_cursor
                walk!(column, origin: [x,y], dimensions: [ current_column_width, height ])
                # render!(column, origin: [x,y], dimensions: [current_column_width, height], mouse_position: mouse_position)

                width_cursor += current_column_width
              end
            end

            height_cursor += row_section_height
          else # no columns in the row
            current_row_height = if !row.height.nil?
                                   row.height
                                 elsif !row.height_percent.nil?
                                   row.height_percent * height
                                 else
                                   row_section_height
                                 end
            x = x0
            y = y0 + height_cursor
            dims = [width, current_row_height]
            walk!(row, origin: [x,y], dimensions: dims) # mouse_position: mouse_position)

            height_cursor += current_row_height
          end
        end
      end
    end
  end

  class ApplicationViewComposer
    include Geometer::PointHelpers
    include Geometer::DimensionHelpers

    def traverse(structure, origin: [0,0], dimensions:, &blk)
      traversal = ViewTraversal.new(&blk) #(structure, origin: origin, dimensions: dimensions)
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
      p [ :CLICK_MOLECULE ]
      send_molecule(structure, window_dims, mouse_position: mouse_position, message: :click)
    end

    def render!(structure, dims)
      traverse(structure, origin: [0,0], dimensions: dims) do
        on_atom do |atom, origin:, dimensions:|
          atom.position = origin
          atom.render
        end

        on_molecule do |molecule, origin:, dimensions:|
          x0,y0 = *origin
          width,height = *dimensions

          pad = molecule.padding || 5.0
          pad_origin = [x0 + pad, y0 + pad ]
          pad_dims = [width - pad*2, height - pad*2 ]

          if molecule.background_color
            molecule.draw_bounding_box(
              color: molecule.background_color,
              origin: pad_origin, dimensions: pad_dims)
          end
        end
      end
    end
  end
end
