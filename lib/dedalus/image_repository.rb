module Dedalus
  class ImageRepository
    def self.lookup(path)
      @images ||= {}
      @images[path] ||= Gosu::Image.new(path)
      @images[path]
    end

    def self.lookup_tiles(path, width, height)
      @tiles ||= {}
      @tiles[path] ||= Gosu::Image::load_tiles(path, width, height)
      @tiles[path]
    end
  end
end
