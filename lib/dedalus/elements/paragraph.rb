module Dedalus
  module Elements
    class Paragraph < Text
      after_create { self.scale ||= 0.75; self.padding ||= 8.0 }
    end
  end
end
