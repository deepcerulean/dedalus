module Dedalus
  class ApplicationView < Joyce::ApplicationView
    def initialize(app)
      super(app)
      Dedalus.activate!(self)
    end

    def compose(screen)
      screen = composer.hover_molecule(screen, dimensions, mouse_position: mouse_position)
      composer.render!(screen, dimensions)

      cursor.position = mouse_position
      cursor.render
    end

    def dimensions
      [window.width, window.height]
    end

    def mouse_position
      if @application.window.fullscreen?
        x0,y0 = *super
        [ x0 * 2, y0 * 2 ]
      else
        super
      end
    end

    protected
    def cursor
      @cursor ||= Elements::Icon.for :arrow_cursor
    end

    private
    def composer
      @composer ||= Dedalus::ApplicationViewComposer.new
    end
  end
end
