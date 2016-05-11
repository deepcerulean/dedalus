module Dedalus
  class Color
    attr_accessor :red, :green, :blue, :alpha

    def initialize(red,green,blue,alpha=160)
      @red = red
      @green = green
      @blue = blue
      @alpha = alpha
    end

    # def mix(other_color)
    #   Color.new( 
    #             (red+other_color.red/2), 
    #             (green+other_color.green/2),
    #             (blue+other_color.blue/2)
    #            )
    # end

    def darken(ratio=0.90)
      Color.new(red*ratio,green*ratio,blue*ratio)
    end

    def lighten(ratio=1.10)
      Color.new(red*ratio,green*ratio,blue*ratio)
    end

    def to_gosu
      Gosu::Color.rgba(red, green, blue, alpha)
    end
  end

  class ColorPalette
    attr_accessor :red, :green, :blue, :yellow, :purple, :gray, :white, :black
    def initialize(
      red:, green:, blue:, yellow:, purple:, gray:, 
      white: Color.new(240,240,240),
      black: Color.new(20,20,20)
    )
      @red = red
      @green = green
      @blue = blue
      @yellow = yellow
      @purple = purple
      @gray = gray
      @white = white
      @black = black
    end

    def decode_color(color)
      return color if color.is_a?(Dedalus::Color)

      case color
      when 'red' then red
      when 'lightred' then red.lighten
      when 'darkred' then red.darken

      when 'green' then green
      when 'lightgreen' then green.lighten
      when 'darkgreen' then green.darken

      when 'blue' then blue
      when 'lightblue' then blue.lighten
      when 'darkblue' then blue.darken

      when 'yellow' then yellow
      when 'lightyellow' then yellow.lighten
      when 'darkyellow' then yellow.darken

      when 'gray' then gray
      when 'lightgray' then gray.lighten
      when 'darkgray' then gray.darken

      when 'purple' then purple
      when 'lightpurple' then purple.lighten
      when 'darkpurple' then purple.darken

      when 'white' then white
      when 'black' then black

      else 
        raise "Unknown color string given to #{self.class.name}#decode_color: #{color}"
      end
    end
  end

  DesaturatedPalette = ColorPalette.new(
    red: Color.new(140, 100, 100),
    green: Color.new(100, 140, 100),
    blue: Color.new(100, 100, 140),
    yellow: Color.new(150, 140, 100),
    purple: Color.new(140, 100, 140),
    gray: Color.new(80, 80, 80)
  )

  Palette = DesaturatedPalette 
end
