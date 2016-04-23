module Dedalus
  module PatternLibrary
    class ApplicationHeader < Dedalus::Organism
      attr_accessor :title, :subtitle

      def show
        [
          heading,
          subheading
        ]
      end

      private
      def heading
        @heading ||= Elements::Heading.new(text: title)
      end

      def subheading
        @subheading ||= Elements::Heading.new(text: subtitle, scale: 0.75)
      end
    end
  end
end

