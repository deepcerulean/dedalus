module Dedalus
  class ImageRepository
    def self.lookup(path)
      @images ||= {}
      @images[path] ||= Gosu::Image.new(path)
      @images[path]
    end

    def self.lookup_tiles(path, width, height)
      @tiles ||= {}
      @tiles[path] ||= Gosu::Image::load_tiles(path, width.to_i, height.to_i)
      @tiles[path]
    end

    def self.lookup_recording(id,width,height,window,force:false,&blk)
      @recordings ||= {}
      if force
        @recordings[id] = window.record(width.to_i,height.to_i,&blk)
      else
        @recordings[id] ||= window.record(width.to_i,height.to_i,&blk)
      end
      @recordings[id]
    end
  end
end
