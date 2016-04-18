module Dedalus
  # try to infer active screen
  def self.activate!(app_view)
    @active_screen = app_view # Joyce::ApplicationView.descendants.first.current
  end

  def self.active_screen
    @active_screen ||= nil
  end

  class Element
    include PassiveRecord
    attr_accessor :position

    # in % as 0.0-1.0 (hint to compositing engine for elements in columns/rows respectively)
    attr_accessor :width_percent, :height_percent

    # raw width/height
    attr_accessor :width, :height

    attr_accessor :padding

    # TODO remove screen attr everywhere...
    def screen
      Dedalus.active_screen
    end

    def draw_bounding_box(origin:, dimensions:, color: 0x70f0f0f0)
      x,y = *origin
      w,h = *dimensions

      screen.window.draw_quad(x,y,color,
                              x,y+h,color,
                              x+w,y,color,
                              x+w,y+h,color,ZOrder::Overlay)
    end
  end

  class Atom < Element
    attr_accessor :scale, :padding

  end

  class Molecule < Element
  end

  class Organism < Element
  end

  class Template < Element
  end

  class Screen < Element
  end

  module ZOrder
    Background, Foreground, Text, Overlay = *(0..5)
  end

  module Elements
    class Image < Dedalus::Atom
      attr_accessor :path, :padding
      after_create { self.padding ||= 0.0 }

      def render #(screen)
        x,y = *position
        p [ drawing_image_at: [x,y]]

        asset.draw(x + padding, y + padding, ZOrder::Foreground, scale, scale)

        draw_bounding_box(origin: [x,y], dimensions: [width + padding*2,height + padding*2])
      end

      def width
        asset.width * scale
      end

      def height
        asset.height * scale
      end

      private
      def asset
        @asset ||= Gosu::Image.new(path)
      end
    end

    class Icon < Image
      after_create { self.scale ||= 0.0618 }

      class << self
        def for(sym)
          @icon_set ||= {}
          @icon_set[sym] ||= create(path: "media/icons/#{sym}.png")
          @icon_set[sym]
        end
      end
    end

    class Heading < Dedalus::Atom
      attr_accessor :text, :scale, :padding
      after_create { self.scale ||= 1.0; self.padding ||= 10.0 }

      def font
        screen.font
      end

      def render(*)
        x,y = *position
        font.draw(text, x + padding, y + padding, ZOrder::Text, self.scale, self.scale)

        draw_bounding_box(origin: [x,y], dimensions: dimensions)
      end

      def width
        2*padding + (font.text_width(text) * scale)
      end

      def height
        2*padding + (font.height * scale)
      end

      def dimensions
        [ width, height ]
      end
    end

    class Paragraph < Dedalus::Atom
      attr_accessor :text, :scale
      after_create { self.scale ||= 0.75 }

      # TODO padding...
      def font; screen.font end

      def render #(screen)
        x,y = *position

        font.draw(text, x, y, ZOrder::Text, self.scale, self.scale)
        draw_bounding_box(origin: [x,y], dimensions: [ font.text_width(text) * scale, font.height * scale ])
      end
    end
  end
end
