module Dedalus
  module Elements
    class Heading < Text
      def scale
        @scale ||= 1.0
      end

      def padding
        @padding ||= 10.0
      end
    end
  end
end
