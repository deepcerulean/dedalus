module Dedalus
  class Palette
    def self.decode_color(color)
      case color
      when 'red' then 0xa0b2543d
      when 'lightred' then 0xb0c2644d

      when 'green' then 0xa092a34c
      when 'lightgreen' then 0xa0a2b35c

      when 'blue' then 0xa0779ecb
      when 'lightblue' then 0xa087aedb

      when 'yellow' then 0xa0FFE89B
      when 'lightyellow' then 0xa0FFF8AB

      when 'gray' then 0xa0c0c0c0
      when 'lightgray' then 0xa0f0f0f0

      else 0x00f0f0f0
      end
    end
  end
end
