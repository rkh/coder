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
end
