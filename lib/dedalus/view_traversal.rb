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

      subdivide_line(rows, distance: height, attr: :height) do |row, current_row_height, height_cursor|
        if row.is_a?(Array)
          subdivide_line(row, distance: width, attr: :width) do |column, current_column_width, width_cursor|
            if column.is_a?(Array) # we have rows INSIDE the columns! i think we need to recurse...
              new_origin = [x0 + width_cursor,y0 + height_cursor]
              new_dims = [ current_column_width, current_row_height ]
              walk!(column, origin: new_origin, dimensions: new_dims)
            else
              x = x0 + width_cursor
              y = y0 + height_cursor
              walk!(column, origin: [x,y], dimensions: [ current_column_width, current_row_height ])

              width_cursor += current_column_width
            end
          end
        else
          x = x0
          y = y0 + height_cursor
          dims = [width, current_row_height]
          walk!(row, origin: [x,y], dimensions: dims)
        end
      end
    end

    def subdivide_line(elements, distance:, attr:)
      elements_with_relative_hints = elements.select do |element|
        if element.is_a?(Array)
          false
        else
          !element.send(:"#{attr}_percent").nil?
        end
      end

      elements_with_absolute_hints = elements.select do |element|
        if element.is_a?(Array)
          false
        else
          !element.send(attr).nil?
        end
      end

      elements_with_hints = elements_with_relative_hints + elements_with_absolute_hints
      distance_specified_by_hints =
        (elements_with_relative_hints.sum(&:"#{attr}_percent") * distance) +
        (elements_with_absolute_hints.sum(&:height))

      default_element_section_distance = (distance - distance_specified_by_hints) / (elements.length - elements_with_hints.length)

      distance_cursor = 0
      elements.each_with_index do |element, index|
        if element.is_a?(Array)
          yield(element, default_element_section_distance, distance_cursor)
          distance_cursor += default_element_section_distance
        else
          current_element_distance = if !element.send(attr).nil?
                                 element.send(attr)
                               elsif !element.send(:"#{attr}_percent").nil?
                                 element.send(:"#{attr}_percent") * distance
                               else
                                 default_element_section_distance
                               end

          yield(element, current_element_distance, distance_cursor)
          distance_cursor += current_element_distance
        end
      end
    end
  end
end
