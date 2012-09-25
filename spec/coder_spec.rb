# encoding: UTF-8
require 'spec_helper'

describe Coder do
  describe :clean do
    it 'cleans up UTF-8 strings without having to specify the encoding' do
      Coder.clean("yummy\xE2 \xF0\x9F\x8D\x94 \x9F\x8D\x94").should binary_equal("yummy 🍔 ")
    end

    it 'allows specifying the encoding' do
      Coder.clean("\x00f\x00ox", "UCS-2BE").should binary_equal("\x00f\x00o")
    end
  end
end
