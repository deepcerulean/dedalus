module Dedalus
  class ApplicationViewComposer
    # TODO note the vertical/horizontal cases are totally symmetrical, maybe we can factor out some shared behavior?
    def render!(structure, origin: [0,0], dimensions:)
      # puts "--- called render!"
      # # structure = element.show

      width, height = *dimensions
      x0, y0 = *origin

      if structure.is_a?(Dedalus::Atom)

        # p [ render_atom_at: origin, element: structure.class.name ]
        structure.update(position: origin)
        structure.render #(app_view)

      elsif structure.is_a?(Dedalus::Element)
        # an element *other than* an atom, we need to call #show on it
        render!(structure.show, origin: origin, dimensions: dimensions)
        structure.draw_bounding_box(origin: origin, dimensions: dimensions)

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
                render!(column, origin: [x0 + width_cursor,y0 + height_cursor], dimensions: [column_section_width, row_section_height])
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
                render!(column, origin: [x,y], dimensions: [current_column_width, height])

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
            render!(row, origin: [x,y], dimensions: dims)

            height_cursor += current_row_height
          end
        end
      end
    end
  end
end
