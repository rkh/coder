# encoding: UTF-8
require 'spec_helper'

shared_examples Coder::Cleaner do
  encoding "UTF-8" do
    cleans "foo"
    cleans ""
    cleans "yummy 🍔 "
    cleans "\0", ""
    cleans "{foo \xC3 'bar'}", "{foo  'bar'}"
    cleans "yummy\xE2 \xF0\x9F\x8D\x94 \x9F\x8D\x94", "yummy 🍔 "
    sets_encoding
  end

  encoding "UCS-2BE" do
    cleans "\x00f\x00o\x00o"
    cleans "\x00f\x00ox", "\x00f\x00o"
    cleans "\x00f\x00o\x00\x00", "\x00f\x00o"
    sets_encoding
  end

  encoding "UCS-4BE" do
    cleans "\x00\x00\x00f\x00\x00\x00o\x00\x00\x00o"
    cleans "\x00\x00\x00f\x00\x00\x00o\x00\x00x", "\x00\x00\x00f\x00\x00\x00o"
    cleans "\x00\x00\x00f\x00\x00\x00o\x00\x00\x00\x00", "\x00\x00\x00f\x00\x00\x00o"
    cleans "\xFF\xFF\x10\x10", ""
    sets_encoding
  end

  context "unknown encoding" do
    it "raises an exception" do
      expect { described_class.new('foobar') }.
        to raise_error(Coder::InvalidEncoding)
    end
  end
end

describe Coder::Cleaner do
  include CleanHelpers
  it_behaves_like Coder::Cleaner

  it { should support('UTF-8') }
  it { should support('UCS-2BE') }
  it { should support('UCS-4BE') }
end

describe Coder::Cleaner::Simple do
  include CleanHelpers
  it_behaves_like Coder::Cleaner

  it { should support('UTF-8') }
  it { should support('UCS-2BE') }
  it { should support('UCS-4BE') }
end

describe Coder::Cleaner::Builtin do
  include CleanHelpers
  it_behaves_like Coder::Cleaner

  it { should support('UTF-8') }
  it { should support('UCS-2BE') }
  it { should support('UCS-4BE') }
end if Coder::Cleaner::Builtin.available?

describe Coder::Cleaner::Java do
  include CleanHelpers
  it_behaves_like Coder::Cleaner

  it { should support('UTF-8') }
  it { should_not support('UCS-2BE') }
  it { should_not support('UCS-4BE') }
end if Coder::Cleaner::Java.available?

describe Coder::Cleaner::Iconv do
  include CleanHelpers
  it_behaves_like Coder::Cleaner

  it { should support('UTF-8') }
  it { should_not support('UCS-2BE') }
  it { should_not support('UCS-4BE') }
end if Coder::Cleaner::Iconv.available?
