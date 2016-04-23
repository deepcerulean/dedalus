module Dedalus
  class Palette
    def self.decode_color(color)
      case color
      when 'red' then 0xffb2543d
      when 'lightred' then 0xffb96045
      when 'darkred' then 0xffa4482c

      when 'green' then 0xff72933c
      when 'lightgreen' then 0xfea1b35c

      when 'blue' then 0xff678ebb
      when 'lightblue' then 0xff779ecb

      when 'yellow' then 0xffbFa86B
      when 'lightyellow' then 0xffdFd89B

      when 'gray' then 0xff707070
      when 'lightgray' then 0xffa0a0a0
      when 'darkgray' then 0xf0404040

      else 0x00f0f0f0
      end
    end
  end
end
