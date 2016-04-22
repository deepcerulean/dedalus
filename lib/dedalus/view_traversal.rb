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

    def on_element(&blk)
      @element_callback = blk
    end

    def walk!(structure, origin:, dimensions:)
      width, height = *dimensions
      x0, y0 = *origin

      if structure.is_a?(Dedalus::Atom)
        @atom_callback.call(structure, origin: origin, dimensions: dimensions) if @atom_callback
      elsif structure.is_a?(Dedalus::Element)
        # an element *other than* an atom, we need to call #show on it
        pad = structure.padding || 2.0
        pad_origin = [x0 + pad, y0 + pad ]
        pad_dims = [width - pad*2, height - pad*2 ]

        if structure.is_a?(Dedalus::Molecule) && @molecule_callback
          @molecule_callback.call(structure, origin: pad_origin, dimensions: pad_dims)
        end

        if @element_callback
          @element_callback.call(structure, origin: pad_origin, dimensions: pad_dims)
        end

        walk!(structure.show, origin: pad_origin, dimensions: pad_dims)

      elsif structure.is_a?(Array) # we have a set of rows
        walk_rows!(structure, origin: origin, dimensions: dimensions)
      end
    end

    def walk_rows!(rows, origin:, dimensions:)
      width, height = *dimensions
      x0, y0 = *origin
      rows_with_percentage_height_hints = rows.select do |row|
        if row.is_a?(Array)
          false
        else
          !row.height_percent.nil?
        end
      end

      rows_with_raw_height_hints = rows.select do |row|
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

      row_section_height = (height - height_specified_by_hints) / (rows.length - rows_with_height_hints.length)

      rows.each_with_index do |row, y_index|
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
              walk!(column, origin: [x,y], dimensions: [ current_column_width, row_section_height ]) # height - height_cursor ])

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
          walk!(row, origin: [x,y], dimensions: dims)

          height_cursor += current_row_height
        end
      end
    end
  end
end

