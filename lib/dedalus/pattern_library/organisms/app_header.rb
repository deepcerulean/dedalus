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

      def padding
        16
      end

      def self.description
        "An application header"
      end

      def self.example_data
        { title: "Fake app", description: "Hello world" }
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

