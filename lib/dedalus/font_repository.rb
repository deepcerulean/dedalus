module Dedalus
  class FontRepository
    def self.get_font(font_name='Helvetica',size: 20)
      @fonts ||= {}
      @fonts[font_name] ||= {}
      @fonts[font_name][size] ||= Gosu::Font.new(size, name: font_name)
      @fonts[font_name][size]
    end
  end
end
