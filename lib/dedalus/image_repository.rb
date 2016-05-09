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

    def self.lookup_recording(id,width,height,window,&blk)
      p [ :lookup_recording, id: id ]
      @recordings ||= {}
      @recordings[id] ||= window.record(width,height,&blk)
      @recordings[id]
    end
  end
end
