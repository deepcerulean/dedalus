module Dedalus
  module Elements
    class Paragraph < Text
      def scale
        @scale ||= 0.75
      end

      def padding
        @padding ||= 2.6
      end
    end
  end
end
