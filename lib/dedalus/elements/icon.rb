module Dedalus
  module Elements
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
  end
end
