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

    def walk!(structure, origin:, dimensions:, freeform: false)
      width, height = *dimensions
      height = structure.height if !structure.is_a?(Array) && structure.height
      width = structure.width if !structure.is_a?(Array) && structure.width
      x0, y0 = *origin

      if structure.is_a?(Dedalus::Atom)
        @atom_callback.call(structure, origin: origin, dimensions: dimensions, freeform: freeform) if @atom_callback
      elsif structure.is_a?(Dedalus::Element)
        # an element *other than* an atom, we need to call #show on it
        margin = structure.margin || 0.0
        x,y = x0 + margin, y0 + margin
        margin_origin = [ x, y ]
        margin_dims = [ width - margin*2, height - margin*2 ]

        if structure.is_a?(Dedalus::Molecule) && @molecule_callback
          @molecule_callback.call(structure, origin: margin_origin, dimensions: margin_dims)
        end

        if @element_callback
          @element_callback.call(structure, origin: margin_origin, dimensions: margin_dims)
        end

        pad = structure.padding || 0.0
        pad_origin = [x+pad,y+pad]
        pad_dims = [width - pad*2 - margin*2, height - pad*2 - margin*2 ]

        if structure.is_a?(LayerStack)
          layers = structure.layers
          layers.each do |layer|
            walk!(layer, origin: pad_origin, dimensions: pad_dims, freeform: layer.freeform?)
          end
        else
          walk!(structure.show, origin: pad_origin, dimensions: pad_dims, freeform: freeform)
        end
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
          extra_columns = true
          while extra_columns 
            row = walk_columns!(row, origin: [x0, y], dimensions: dims)
            if row.empty?
              extra_columns = false
            else
              height_cursor += row.first.height
              y = y0 + height_cursor
            end
          end
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
      percent_attr = :"#{attr}_percent"
      elements_with_relative_hints = elements.select do |element|
        if element.is_a?(Array)
          false
        else
          !element.send(percent_attr).nil?
        end
      end

      elements_with_absolute_hints = elements.select do |element|
        if element.is_a?(Array)
          false
        else
          !element.send(attr).nil?
        end
      end

      elements_with_hints = (elements_with_relative_hints + elements_with_absolute_hints).uniq
      distance_specified_by_hints =
        (elements_with_relative_hints.sum(&percent_attr) * distance) +
        (elements_with_absolute_hints.sum(&attr))

      if elements_with_hints.length < elements.length
        default_element_section_distance = (distance - distance_specified_by_hints) / (elements.length - elements_with_hints.length)
      end

      distance_cursor = 0
      elements.each_with_index do |element, index|
        current_element_distance = if element.is_a?(Array)
          default_element_section_distance
        else
          if !element.send(attr).nil?
            element.send(attr)
          elsif !element.send(percent_attr).nil?
            element.send(percent_attr) * distance
          else
            default_element_section_distance
          end
        end

        if distance_cursor > distance - current_element_distance # ??
          return elements.slice(index,elements.size)
        end

        yield(element, current_element_distance, distance_cursor)
        distance_cursor += current_element_distance
      end

      # no overflowing elements...
      []
    end
  end
end
