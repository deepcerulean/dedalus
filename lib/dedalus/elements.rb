module Dedalus
  # try to infer active screen
  def self.activate!(app_view)
    @active_screen = app_view # Joyce::ApplicationView.descendants.first.current
  end

  def self.active_screen
    @active_screen ||= nil
  end

  class Element
    attr_accessor :position

    # in % as 0.0-1.0 (hint to compositing engine for elements in columns/rows respectively)
    attr_accessor :width_percent, :height_percent

    # raw width/height
    attr_accessor :width, :height

    attr_accessor :padding
    attr_accessor :background_color

    def initialize(attrs={})
      attrs.each { |(k,v)| instance_variable_set(:"@#{k}",v) }
    end

    # TODO remove screen attr everywhere...
    # TODO rename, since this is really the app_view..?
    def screen
      Dedalus.active_screen
    end

    def draw_bounding_box(origin:, dimensions:, color: 0x70f0f0f0, highlight: false)
      x,y = *origin
      w,h = *dimensions

      color = 0xa0f0f0f0 if highlight

      screen.window.draw_quad(x,y,color,
                              x,y+h,color,
                              x+w,y,color,
                              x+w,y+h,color,ZOrder::Background)
    end
  end

  ###

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
end
