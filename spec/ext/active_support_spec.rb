# encoding: UTF-8
require 'spec_helper'
require 'coder/ext/active_support'

describe ActiveSupport::JSON do
  it 'still escapes unicode properly' do
    ActiveSupport::JSON.encode('€2.99').should be == '"\\u20ac2.99"'
  end

  it 'still encodes unicode properly' do
    ActiveSupport::JSON.encode('€2.99').encoding.should be == Encoding::UTF_8
  end if defined? Encoding::UTF_8

  it 'actually uses Coder internally' do
    Coder.should_receive(:clean).with('€2.99').and_return('€2.99')
    ActiveSupport::JSON.encode('€2.99')
  end
end
