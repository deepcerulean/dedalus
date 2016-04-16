require 'spec_helper'
require 'dedalus'

describe Dedalus do
  it "should have a VERSION constant" do
    expect(subject.const_get('VERSION')).to_not be_empty
  end
end
