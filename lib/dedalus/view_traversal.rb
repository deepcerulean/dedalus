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
        pad = structure.padding || 0.0
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

    private
    def walk_rows!(rows, origin:, dimensions:)
      width, height = *dimensions
      x0, y0 = *origin

      subdivide_line(rows, distance: height, attr: :height) do |row, current_row_height, height_cursor|
        y = y0 + height_cursor
        dims = [width, current_row_height]
        if row.is_a?(Array)
          walk_columns!(row, origin: [x0, y], dimensions: dims)
        else
          walk!(row, origin: [x0,y], dimensions: dims)
        end
      end
    end

    def walk_columns!(columns, origin:, dimensions:)
      width, height = *dimensions
      x0, y0 = *origin
      subdivide_line(columns, distance: width, attr: :width) do |column, current_column_width, width_cursor|
        x = x0 + width_cursor
        dims = [ current_column_width, height ]
        walk!(column, origin: [x,y0], dimensions: dims)
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
        (elements_with_absolute_hints.sum(&attr))

      default_element_section_distance = (distance - distance_specified_by_hints) / (elements.length - elements_with_hints.length)

      distance_cursor = 0
      elements.each_with_index do |element, index|
        current_element_distance = if element.is_a?(Array)
          default_element_section_distance
        else
          if !element.send(attr).nil?
            element.send(attr)
          elsif !element.send(:"#{attr}_percent").nil?
            element.send(:"#{attr}_percent") * distance
          else
            default_element_section_distance
          end
        end

        yield(element, current_element_distance, distance_cursor)
        distance_cursor += current_element_distance
      end
    end
  end
end
