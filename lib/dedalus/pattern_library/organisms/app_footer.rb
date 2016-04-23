module Dedalus
  module PatternLibrary
    class ApplicationFooter < Dedalus::Organism
      attr_accessor :joyce_version, :dedalus_version, :company, :copyright

      def show
        [ footer_message ]
      end

      def padding
        20
      end

      def self.description
        "An application footer"
      end

      def self.example_data
        { 
          joyce_version: "x.y.z", 
          dedalus_version: "a.b.c",
          company: "Hello LLC",
          copyright: "All rights reserved" 
        }
      end

      private
      def footer_message
        @footer_message ||=  Elements::Paragraph.new(text: assemble_text, scale: 0.5)
      end

      def assemble_text
        "Powered by Dedalus v#{dedalus_version} and Joyce v#{joyce_version}. Copyright #{company} #{copyright}. All rights reserved."
      end
    end
  end
end
