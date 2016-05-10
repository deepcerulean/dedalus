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

    def self.lookup_recording(id,width,height,window,&blk)
      # p [ :lookup_recording, id: id ]
      @recordings ||= {}
      @recordings[id] ||= window.record(width.to_i,height.to_i,&blk)
      @recordings[id]
    end

    # TODO could handle overflows/alignment in text (should use for code...?)
    # def self.lookup_text(text, line_height)
    #   @text_images ||= {}
    #   @text_images[text] ||= Gosu::Image.from_text(text, line_height)
    #   @text_images[text]
    # end
  end
end
