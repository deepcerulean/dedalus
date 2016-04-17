module Dedalus
  class ApplicationViewComposer
    attr_reader :app_view

    def initialize(app_view)
      @app_view = app_view
    end

    def window_dimensions
      [ app_view.window.width, app_view.window.height ]
    end

    # TODO note the vertical/horizontal cases are totally symmetrical, maybe we can factor out some shared behavior?
    def render!(structure, origin: [0,0], dimensions: window_dimensions)
      # puts "--- called render!"
      # # structure = element.show

      width, height = *dimensions
      x0, y0 = *origin

      if structure.is_a?(Dedalus::Atom)

        structure.update(position: origin)
        structure.render(app_view)

      elsif structure.is_a?(Dedalus::Element)
        # an element *other than* an atom, we need to call #show on it
        render!(structure.show, origin: origin, dimensions: dimensions)

      elsif structure.is_a?(Array) # we have a set of rows
        rows_with_height_hints = structure.select do |row|
          if row.is_a?(Array)
            false #row.any? { |col| !col.height.nil? }
          else
            !row.height.nil?
          end
        end

        height_specified_by_hints = rows_with_height_hints.sum(&:height) * height.to_f
        height_cursor = 0

        row_section_height = (height - height_specified_by_hints) / (structure.length - rows_with_height_hints.length) #.to_f)
        structure.each_with_index do |row, y_index|
          if row.is_a?(Array) # we have columns within the row
            columns_with_height_hints = row.select do |column|
              if column.is_a?(Array)
                false
              else
                !column.width.nil?
              end
            end

            width_specified_by_hints = columns_with_height_hints.sum(&:width) * width.to_f
            width_cursor = 0

            column_section_width = (width - width_specified_by_hints) / (row.length - columns_with_height_hints.length) #.to_f)
            row.each_with_index do |column, x_index|
              if column.is_a?(Array) # we have rows INSIDE the columns! i think we need to recurse...
                render!(column, origin: [x0,y0], dimensions: [column_section_width, row_section_height])
              else
                current_column_width = column.width.nil? ? column_section_width : (column.width * width)
                x = x0 + width_cursor
                y = y0 + height_cursor
                render!(column, origin: [x,y], dimensions: [current_column_width, height])

                width_cursor += current_column_width
              end
            end

            height_cursor += row_section_height
          else # no columns in the row
            current_row_height = row.height.nil? ? row_section_height : (row.height * height)
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
