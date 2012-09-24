# encoding: UTF-8
require 'coder/cleaner'
require 'coder/error'

shared_examples Coder::Cleaner do
  let(:encoding) { example.example_group.description }
  subject { described_class.new(encoding) }

  def self.cleans(from, to = from)
    it "cleans #{from.inspect} to #{to.inspect}" do
      next unless described_class.supports? encoding
      result = subject.clean(binary(from))
      binary(result).should be == binary(to)
    end
  end

  def binary(str)
    return str unless str.respond_to? :force_encoding
    str.force_encoding('binary')
  end

  context "UTF-8" do
    cleans "foo"
    cleans ""
    cleans "yummy 🍔 "
    cleans "\0", ""

    cleans "{foo \xC3 'bar'}", "{foo  'bar'}"
    cleans "yummy\xE2 \xF0\x9F\x8D\x94 \x9F\x8D\x94", "yummy 🍔 "
  end

  context "UCS-2BE" do
    cleans "\x00f\x00o\x00o"
    cleans "\x00f\x00ox", "\x00f\x00o"
    cleans "\x00f\x00o\x00\x00", "\x00f\x00o"
  end

  context "UCS-4BE" do
    cleans "\x00\x00\x00f\x00\x00\x00o\x00\x00\x00o"
    cleans "\x00\x00\x00f\x00\x00\x00o\x00\x00x", "\x00\x00\x00f\x00\x00\x00o"
    cleans "\x00\x00\x00f\x00\x00\x00o\x00\x00\x00\x00", "\x00\x00\x00f\x00\x00\x00o"
    cleans "\xFF\xFF\x10\x10", ""
  end

  context "Unknown Encoding" do
    it { expect { subject }.to raise_error(Coder::InvalidEncoding) }
  end
end

describe Coder::Cleaner do
  it_behaves_like Coder::Cleaner if described_class.available?
end

describe Coder::Cleaner::Builtin do
  it_behaves_like Coder::Cleaner if described_class.available?
end

describe Coder::Cleaner::Java do
  it_behaves_like Coder::Cleaner if described_class.available?
end

describe Coder::Cleaner::Iconv do
  it_behaves_like Coder::Cleaner if described_class.available?
end

describe Coder::Cleaner::Simple do
  it_behaves_like Coder::Cleaner if described_class.available?
end
