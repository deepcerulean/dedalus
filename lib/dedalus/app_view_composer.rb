module Dedalus
  class ApplicationViewComposer
    include Geometer::PointHelpers
    include Geometer::DimensionHelpers

    # TODO note the vertical/horizontal cases are totally symmetrical, maybe we can factor out some shared behavior?
    def render!(structure, origin: [0,0], dimensions:, mouse_position:)
      width, height = *dimensions
      x0, y0 = *origin

      if structure.is_a?(Dedalus::Atom)
        render_atom(structure, origin: origin)
      elsif structure.is_a?(Dedalus::Element)
        # an element *other than* an atom, we need to call #show on it

        mouse_coord = coord(*mouse_position)
        element_bounding_box = Geometer::Rectangle.new(coord(*origin), dim(*dimensions))
        # could check for mouse position overlay?
        mouse_hovering = element_bounding_box.contains?(mouse_coord)
        # could just call on hover here right before render..?
        # would be good to separate all this out...
        structure.hover if mouse_hovering

        pad = structure.padding || 5.0
        pad_origin = [x0 + pad, y0 + pad ]
        pad_dims = [width - pad*2, height - pad*2 ]

        if structure.background_color
          structure.draw_bounding_box(color: structure.background_color, origin: pad_origin, dimensions: pad_dims, highlight: mouse_hovering)
        end

        render!(structure.show, origin: pad_origin, dimensions: pad_dims, mouse_position: mouse_position)

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
                render!(column, origin: [x0 + width_cursor,y0 + height_cursor], dimensions: [column_section_width, row_section_height], mouse_position: mouse_position)
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
                render!(column, origin: [x,y], dimensions: [current_column_width, height], mouse_position: mouse_position)

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
            render!(row, origin: [x,y], dimensions: dims, mouse_position: mouse_position)

            height_cursor += current_row_height
          end
        end
      end
    end


    def render_atom(atom, origin:)
      atom.position = origin
      atom.render
    end
  end
end
