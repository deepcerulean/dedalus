module Dedalus
  class Element
    include PassiveRecord
    attr_accessor :position

    # in % as 0.0-1.0 (hint to compositing engine for elements in columns/rows respectively)
    attr_accessor :width, :height
  end

  class Atom < Element
    attr_accessor :scale
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
    Background, Foreground, Text = *(0..3)
  end

  module Elements
    class Image < Dedalus::Atom
      attr_accessor :path

      def render(screen)
        x,y = *position
        asset.draw(x, y, ZOrder::Foreground, scale, scale)
      end

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
      attr_accessor :text, :scale
      after_create { self.scale ||= 1.0 }

      def render(screen)
        x,y = *position
        screen.font.draw(text, 20 + x, 20 + y, ZOrder::Text, self.scale, self.scale)
      end
    end

    class Paragraph < Dedalus::Atom
      attr_accessor :text, :scale
      after_create { self.scale ||= 0.5 }

      def render(screen)
        x,y = *position
        screen.font.draw(text, 20 + x, 20 + y, ZOrder::Text, self.scale, self.scale)
      end
    end
  end
end
