# encoding: UTF-8
require 'coder/cleaner'
require 'coder/error'

shared_examples Coder::Cleaner do
  let(:encoding) { example.example_group.description }
  subject { described_class.new(encoding) }

  def self.cleans(from, to = from)
    it "cleans #{from.inspect} to #{to.inspect}" do
      subject.clean(from).should be == to
    end
  end

  context "UTF-8" do
    cleans "foo"
    cleans ""
    cleans "yummy 🍔 "

    cleans "{foo \xC3 'bar'}", "{foo  'bar'}"
    cleans "yummy\xE2 \xF0\x9F\x8D\x94 \x9F\x8D\x94", "yummy 🍔 "
  end

  context "Unknown Encoding" do
    it { expect { subject }.to raise_error(Coder::InvalidEncoding) }
  end
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
