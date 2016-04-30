module Dedalus
  module Elements
    class Void < Dedalus::Atom
      attr_accessor :width, :height
      def render(*); end

      def self.description
        'an empty space'
      end

      def self.example_data
        { width: 300, height: 300 }
      end
    end
  end
end
