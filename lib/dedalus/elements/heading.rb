module Dedalus
  module Elements
    class Heading < Text
      after_create { self.scale ||= 1.0; self.padding ||= 10.0 }
    end
  end
end
