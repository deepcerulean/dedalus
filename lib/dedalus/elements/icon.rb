module Dedalus
  module Elements
    class Icon < Image
      def scale
        @scale ||= 0.062
      end

      class << self
        def for(sym, attrs={})
          @icon_set ||= {}
          @icon_set[sym] ||= new(attrs.merge(path: "media/icons/#{sym}.png"))
          @icon_set[sym]
        end
      end
    end
  end
end
