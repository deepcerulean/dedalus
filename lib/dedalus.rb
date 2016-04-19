require 'joyce'
require 'geometer'

require 'dedalus/version'
require 'dedalus/app_view_composer'

require 'dedalus/elements'
require 'dedalus/elements/text'
require 'dedalus/elements/heading'
require 'dedalus/elements/paragraph'
require 'dedalus/elements/image'
require 'dedalus/elements/icon'

require 'dedalus/pattern_library'
require 'dedalus/pattern_library/application_view'
require 'dedalus/pattern_library/application'

module Dedalus
  class Palette
    def self.decode_color(color)
      case color
      when 'red' then 0xa0b2543d
      when 'green' then 0xa092a34c
      when 'blue' then 0xa0779ecb
      when 'yellow' then 0xa0FFE89B
      else 0xf0f0f0f0
      end
    end
  end
end
