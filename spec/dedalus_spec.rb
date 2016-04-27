require 'spec_helper'
require 'dedalus'

describe Dedalus do
  it "should have a VERSION constant" do
    expect(subject.const_get('VERSION')).to_not be_empty
  end
end

describe ApplicationViewComposer do
  before { Dedalus.activate!(app_view) }
  subject(:composer) { ApplicationViewComposer.new }
  let(:app_view) { instance_double(Dedalus::ApplicationView, font: font) }
  let(:font) { instance_double(Gosu::Font, height: 10, text_width: 10) }
  describe "#render" do
    context "a single atom" do
      let(:atom) { Dedalus::Elements::Paragraph.new }
      let(:origin) { [0,0] }
      let(:dimensions) { [1024,720] }

      it 'should update position and render' do
        expect(atom).to receive(:position=).with(origin)
        expect(atom).to receive(:render)
        composer.render!(atom, origin: origin, dimensions: dimensions,mouse_position: [0,0])
      end
    end
  end
end
