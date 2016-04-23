module Dedalus
  module Elements
    class Heading < Text
      def scale
        @scale ||= 2.4
      end

      def padding
        @padding ||= 4.0
      end
    end
  end
end
