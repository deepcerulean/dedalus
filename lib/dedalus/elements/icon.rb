module Dedalus
  module Elements
    class Icon < Image
      attr_accessor :name

      def scale
        @scale ||= 0.062
      end

      def path
        @path ||= "media/icons/#{name}.png"
      end

      class << self
        def for(sym, attrs={})
          @icon_set ||= {}
          @icon_set[sym] ||= new(name: sym) #
          @icon_set[sym]
        end
      end
    end
  end
end
