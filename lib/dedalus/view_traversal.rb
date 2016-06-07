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

    def walk!(structure, origin:, dimensions:, freeform: false, render: false, z_index: ZOrder::Background)
      width, height = *dimensions

      height = structure.height if !structure.is_a?(Array) && structure.height
      width  = structure.width  if !structure.is_a?(Array) && structure.width

      x0, y0 = *origin

      if structure.is_a?(Dedalus::Atom)
        @atom_callback.call(structure, origin: origin, dimensions: dimensions, freeform: freeform, z_index: z_index) if @atom_callback

      # implicitly array is rows, nested arrays are columns, doubly-nested arrays are rows, etc
      elsif structure.is_a?(Array)
        walk_rows!(structure, origin: origin, dimensions: dimensions, render: render)

      elsif structure.is_a?(Dedalus::Element)
        offset = structure.offset || [0,0]
        ox,oy = *offset

        # an element *other than* an atom, we need to call #show on it
        margin = structure.margin || 0.0
        x,y = x0 + ox + margin, y0 + oy + margin

        margin_origin = [ x, y ]
        margin_dims = [ width - margin*2, height - margin*2 ]

        if structure.is_a?(Dedalus::Molecule) && @molecule_callback
          @molecule_callback.call(structure, origin: margin_origin, dimensions: margin_dims, z_index: z_index)
        end

        if @element_callback
          @element_callback.call(structure, origin: margin_origin, dimensions: margin_dims, z_index: z_index)
        end

        pad = structure.padding || 0.0
        pad_origin = [x+pad,y+pad]
        pad_dims = [width - pad*2 - margin*2, height - pad*2 - margin*2 ]

        if structure.is_a?(LayerStack)
          structure.layers.each do |layer|
            if layer.freeform?
              if layer.shown.is_a?(Array)
                layer.elements.each_with_index do |layer_element, z_offset|
                  walk!(layer_element, origin: pad_origin, dimensions: pad_dims, freeform: true, render: render, z_index: z_index+z_offset)
                end
              else
                walk!(layer.elements, origin: pad_origin, dimensions: pad_dims, freeform: true, render: render, z_index: z_index)
              end
            else
              walk!(layer.elements, origin: pad_origin, dimensions: pad_dims, freeform: false, render: render, z_index: z_index)
            end
          end
        else
          if structure.record? && render
            recorded_image = ImageRepository.lookup_recording(structure.name, structure.width, structure.height, structure.window, force: structure.rerecord?) do
              walk!(structure.shown, origin: [0,0], dimensions: pad_dims, freeform: freeform, render: render)
            end

            ox,oy = *pad_origin
            recorded_image.draw(ox,oy,z_index)
          else
            walk!(structure.shown, origin: pad_origin, dimensions: pad_dims, freeform: freeform, render: render, z_index: z_index)
          end
        end
      end
    rescue => ex
      puts "ERROR: Encountered an error with structure of type #{structure.class.name}"
      p ex.message
      p ex.backtrace
      raise ex
    end

    private
    def walk_rows!(rows, origin:, dimensions:, render: false)
      width, height = *dimensions
      x0, y0 = *origin

      subdivide_line(rows, distance: height, attr: :height) do |row, current_row_height, height_cursor|
        y = y0 + height_cursor
        dims = [width, current_row_height]
        if row.is_a?(Array)
          extra_columns = true
          while extra_columns
            row = walk_columns!(row, origin: [x0, y], dimensions: dims, render: render)
            if row.empty?
              extra_columns = false
            else
              height_cursor += row.first.height
              y = y0 + height_cursor
            end
          end
        else
          walk!(row, origin: [x0,y], dimensions: dims, render: render)
        end
      end
    end

    def walk_columns!(columns, origin:, dimensions:, render: false)
      width, height = *dimensions
      x0, y0 = *origin

      subdivide_line(columns, distance: width, attr: :width) do |column, current_column_width, width_cursor|
        x = x0 + width_cursor
        dims = [ current_column_width, height ]
        walk!(column, origin: [x,y0], dimensions: dims, render: render)
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

        if distance_cursor > distance - current_element_distance
          return elements.slice(index,elements.size)
        end

        yield(element, current_element_distance, distance_cursor)
        distance_cursor += current_element_distance
      end

      []
    end
  end
end
