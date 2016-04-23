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
          new(attrs.merge(name: sym))
        end
      end
    end
  end
end
