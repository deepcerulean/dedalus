module Dedalus
  def self.activate!(app_view)
    @active_view = app_view
  end

  def self.active_view
    @active_view ||= nil
  end

  class FontRepository
    def self.get_font(size: 20)
      @fonts ||= {}
      @fonts[size] ||= Gosu::Font.new(size)
      @fonts[size]
    end
  end

  class Element
    attr_accessor :position

    # in % as 0.0-1.0 (hint to compositing engine for elements in columns/rows respectively)
    attr_accessor :width_percent, :height_percent

    # raw width/height
    attr_accessor :width, :height

    attr_accessor :padding, :margin
    attr_accessor :background_color

    def initialize(attrs={})
      attrs.each { |(k,v)| instance_variable_set(:"@#{k}",v) } unless attrs.nil?
    end

    def draw_bounding_box(origin:, dimensions:, color: Palette.gray) #, highlight: false)
      x,y = *origin
      w,h = *dimensions

      raise "Invalid color #{color} given to #{self.class.name} for bounding box" unless color.is_a?(Dedalus::Color)

      c = color.to_gosu
      window.draw_quad(x,y,c,
                       x,y+h,c,
                       x+w,y,c,
                       x+w,y+h,c,ZOrder::Background)
    end

    def view
      Dedalus.active_view
    end

    def font
      FontRepository.get_font(size: 20)
    end

    def big_font
      FontRepository.get_font(size: 36)
    end

    def huge_font
      FontRepository.get_font(size: 120)
    end

    def window
      view.window
    end
  end

  ###

  class Atom < Element
    attr_accessor :scale, :padding
  end

  class Molecule < Element
    def click
    end

    def hover
    end
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
end
