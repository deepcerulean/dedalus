module Dedalus
  module PatternLibrary
    class ApplicationFooter < Dedalus::Organism
      attr_accessor :joyce_version, :dedalus_version, :company, :copyright

      def show
        [ footer_message ]
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
