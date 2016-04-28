module Dedalus
  module Elements
    class Heading < Text
      def font
        big_font
      end

      def padding
        @padding ||= 2.0
      end
    end
  end
end
