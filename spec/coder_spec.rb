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

  describe :force_encoding do
    it 'returns a different string' do
      str = ''
      Coder.force_encoding(str).should_not be_equal(str)
    end

    it 'leaves the content untouched' do
      Coder.force_encoding('foo').should be == 'foo'
    end

    if ''.respond_to? :force_encoding
      it 'sets the encoding to UTF-8' do
        Coder.force_encoding(''.encode('binary')).encoding.name.should be == 'UTF-8'
      end

      it 'allows specifying a different encoding' do
        Coder.force_encoding(''.encode('binary'), 'UTF-16BE').encoding.name.should be == 'UTF-16BE'
      end

      it 'does not modify the encoding of the passed in string' do
        str = ''.encode('binary')
        Coder.force_encoding str
        str.encoding.should be == Encoding::BINARY
      end
    end
  end

  describe :force_encoding! do
    it 'returns the string' do
      str = ''
      Coder.force_encoding!(str).should be_equal(str)
    end

    if ''.respond_to? :force_encoding
      it 'sets the encoding to UTF-8' do
        Coder.force_encoding!(''.encode('binary')).encoding.name.should be == 'UTF-8'
      end

      it 'allows specifying a different encoding' do
        Coder.force_encoding!(''.encode('binary'), 'UTF-16BE').encoding.name.should be == 'UTF-16BE'
      end

      it 'modifies the encoding of the passed in string' do
        str = ''.encode('binary')
        Coder.force_encoding! str
        str.encoding.name.should be == 'UTF-8'
      end
    end
  end
end
